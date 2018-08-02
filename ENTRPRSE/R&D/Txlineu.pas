unit TxLineU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Math, TEditVal, Mask, ComCtrls, ExtCtrls, SBSPanel,

  GlobVar,VarConst,ExWrap1U,BorBtns,BTSupU1,

  {$IFDEF STK}
    SalTxl2U,

    {$IFDEF SOP}
      InvLst3U,
      mbdLineFrame, //PR 17/04/2009
//      DebugFuncs,
    {$ENDIF}
  {$ENDIF}

  {$IFDEF EXSQL}
    SQLUtils,
    {$IFDEF BoMObj}
      TxLineObj,
    {$ENDIF}
  {$ENDIF}

  SalTxl1U, Buttons;

{$I DEFOVR.Inc}

type
  // CJS 2016-01-18 - ABSEXCH-17102 - 4.5 - Intrastat on Transaction Line
  TLineState = (lsAdd, lsInsert, lsEdit, lsView);
  TTxLine = class(TForm)
    PageControl1: TPageControl;
    DE1Page: TTabSheet;
    De2Page: TTabSheet;
    DE3Page: TTabSheet;
    Id1Panel: TSBSPanel;
    Id1ItemLab: Label8;
    Id1UPLab: Label8;
    Id1DiscLab: Label8;
    Id1LTotLab: Label8;
    Id1QtyLab: Label8;
    DE4Page: TTabSheet;
    SBSPanel7: TSBSPanel;
    Label831: Label8;
    Label833: Label8;
    Label834: Label8;
    Label835: Label8;
    SBSPanel8: TSBSPanel;
    Label836: Label8;
    PickLab: Label8;
    Id1ItemF: Text8Pt;
    Id1QtyF: TCurrencyEdit;
    Id1SBox: TScrollBox;
    Id1Desc1F: Text8Pt;
    Id1Desc2F: Text8Pt;
    Id1Desc3F: Text8Pt;
    Id1Desc4F: Text8Pt;
    Id1Desc5F: Text8Pt;
    Id1UPriceF: TCurrencyEdit;
    Id1LTotF: TCurrencyEdit;
    Id3SCodeF: Text8Pt;
    Id3SBox: TScrollBox;
    Id3Desc1F: Text8Pt;
    Id3Desc2F: Text8Pt;
    Id3Desc3F: Text8Pt;
    Id3Desc4F: Text8Pt;
    Id3Desc5F: Text8Pt;
    Id3LocF: Text8Pt;
    Id4QOF: TCurrencyEdit;
    Id4QDF: TCurrencyEdit;
    Id4QWF: TCurrencyEdit;
    Id4QOSF: TCurrencyEdit;
    ID4QPTF: TCurrencyEdit;
    Id4QWTF: TCurrencyEdit;
    Id1Desc6F: Text8Pt;
    Id3Desc6F: Text8Pt;
    Id1DiscF: Text8Pt;
    Id3Panel3: TSBSPanel;
    UDF1L: Label8;
    UDF3L: Label8;
    UDF2L: Label8;
    UDF4L: Label8;
    OkCP1Btn: TButton;
    CanCP1Btn: TButton;
    LUD1F: Text8Pt;
    LUD3F: Text8Pt;
    LUD4F: Text8Pt;
    LUD2F: Text8Pt;
    scrMultiBuy: TScrollBox;
    lblMultiBuy: TLabel;
    pnlService: TPanel;
    lblServiceTo: TLabel;
    chkService: TBorCheck;
    dtServiceStart: TEditDate;
    dtServiceEnd: TEditDate;
    Id3Panel: TSBSPanel;
    Id3SCodeLab: Label8;
    id3LocLab: Label8;
    pnlWebExtensions: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label87: Label8;
    edtReference: Text8Pt;
    edtFromPostCode: Text8Pt;
    edtReceiptNo: Text8Pt;
    edtToPostCode: Text8Pt;
    pnlValues: TPanel;
    Id3PQLab: Label8;
    Id3QtyLab: Label8;
    Id3UPLab: Label8;
    Id3DiscLab: Label8;
    Id3LTotLab: Label8;
    lblOtherDiscounts: Label8;
    lblMBDiscount: Label8;
    lblTransDiscount: Label8;
    Label81: Label8;
    Label82: Label8;
    VATCCLab3: Label8;
    Label85: Label8;
    Id3CostLab: Label8;
    Label83: Label8;
    DelDateLab: Label8;
    Id5JCodeF: Text8Pt;
    Id5JAnalF: Text8Pt;
    Id3DepF: Text8Pt;
    Id3CCF: Text8Pt;
    Id3VATF: TSBSComboBox;
    Id3NomF: Text8Pt;
    Id3LTF: TSBSComboBox;
    GLDescF: Text8Pt;
    edtMultiBuy: Text8Pt;
    edtTransDiscount: Text8Pt;
    Id3DiscF: Text8Pt;
    Id3DelF: TEditDate;
    Id3CostF: TCurrencyEdit;
    Id3LTotF: TCurrencyEdit;
    Id3PQtyF: TCurrencyEdit;
    Id3QtyF: TCurrencyEdit;
    Id3UPriceF: TCurrencyEdit;
    Bevel1: TBevel;
    lblUdf5: Label8;
    lblUdf8: Label8;
    lblUdf6: Label8;
    lblUdf9: Label8;
    lblUdf7: Label8;
    lblUdf10: Label8;
    bevUDFs: TBevel;
    edtUdf5: Text8Pt;
    edtUdf8: Text8Pt;
    edtUdf6: Text8Pt;
    edtUdf9: Text8Pt;
    edtUdf7: Text8Pt;
    edtUdf10: Text8Pt;
    IntrastatPage: TTabSheet;
    lblIntrastatInstructions: TLabel;
    chkOverrideIntrastat: TCheckBox;
    lblCommodityCode: TLabel;
    edtStockUnits: TCurrencyEdit;
    lblStockUnits: TLabel;
    edtLineUnitWeight: TCurrencyEdit;
    lblLineUnitWeight: TLabel;
    lblGoodsToCountry: TLabel;
    chkCountry: TRadioButton;
    chkQRCode: TRadioButton;
    lblNoTc: TLabel;
    lblSSDUplift: TLabel;
    edtSSDUplift: TCurrencyEdit;
    cbIntrastatCountry: TSBSComboBox;
    cbNoTc: TSBSComboBox;
    edtCommodityCode: TMaskEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CanCP1BtnClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject;
      var AllowChange: Boolean);
    procedure Id3SCodeFExit(Sender: TObject);
    procedure Id3PQtyFExit(Sender: TObject);
    procedure Id3NomF2Exit(Sender: TObject);
    procedure Id1CCFExit(Sender: TObject);
    procedure Id1Desc1FKeyPress(Sender: TObject; var Key: Char);
    procedure Id3UPriceFExit(Sender: TObject);
    procedure Id3PQtyFEnter(Sender: TObject);
    procedure Id3DiscFoldExit(Sender: TObject);
    procedure Id3DiscFoldEnter(Sender: TObject);
    procedure Id5JCodeFExit(Sender: TObject);
    procedure Id5JAnalFExit(Sender: TObject);
    procedure ID4QPTFExit(Sender: TObject);
    procedure ID4QPTFEnter(Sender: TObject);
    procedure Id3UPriceFEnter(Sender: TObject);
    procedure Id3VATFExit(Sender: TObject);
    procedure Id3SBoxExit(Sender: TObject);
    procedure Id3SCodeFDblClick(Sender: TObject);
    procedure Id3Desc1FKeyPress(Sender: TObject; var Key: Char);
    procedure FormDeactivate(Sender: TObject);
    procedure Id3LocFExit(Sender: TObject);
    procedure Id3LocFEnter(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Id3CostFDeleteMeEnter(Sender: TObject);
    procedure LUD1FExit(Sender: TObject);
    procedure LUD1FEntHookEvent(Sender: TObject);
    procedure Id3VATFEnter(Sender: TObject);
    procedure Id3SCodeFEnter(Sender: TObject);
    procedure LineExtF1Resize(Sender: TObject);
    procedure edtMultiBuyExit(Sender: TObject);
    procedure chkServiceClick(Sender: TObject);
    procedure chkServiceMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Id3VATFClick(Sender: TObject);
    procedure LineExtF1CloseUp(Sender: TObject);
    procedure Id3CostFDeleteMeExit(Sender: TObject);
    procedure edtMultiBuyEnter(Sender: TObject);
    procedure edtTransDiscountEnter(Sender: TObject);
    procedure Id3DelFDeleteEnter(Sender: TObject);
    procedure Id3DelFDeleteExit(Sender: TObject);
    procedure chkOverrideIntrastatClick(Sender: TObject);
    procedure chkCountryClick(Sender: TObject);
    procedure chkQRCodeClick(Sender: TObject);
    procedure Id3VATFDropDown(Sender: TObject);

  private
    { Private declarations }


    DocHed       :  DocTypes;
    bHelpContextInc, //NF: 12/04/06
    BeenInLocSplit,
    FirstQty,
    InPassing,
    InOutId,
    GenSelect,
    IdStored,
    StopPageChange,
    fBadQty,
    fBadPickQty,
    fFrmClosing,
    FormJustCreated,
    HadDefLoc,
    DelLnk,
    NegQtyChk,
    PassStore,
    JustCreated,
    FUnitPriceChanged: Boolean;


    StkChkCnst   :  SmallInt;
    LastPickValue,
    LastQtyValue :  Double;

    PageView     :  Array[1..3] of TDetCtrl;

    ExtList      :  Array[1..22] of TControl;

    LastLineDesc,
    LineDesc     :  TLineDesc;

    {$IFDEF STK}
      DispStk      :  TFStkDisplay;
      {$IFDEF SOP}
        TxAutoMLId :  MLIdOPtr;

        OriginalTabNext : TWinControl; //Used to store next component for ExtendedForm

      {$ENDIF}
    {$ENDIF}

    {$IFDEF BoMObj}
      oLineBoMHelper : TLineBoMHelper;
    {$ENDIF}

    FTransBeingEdited : Boolean;

    //PR: 23/08/2012 ABSEXCH-13333 Keep track of original total on order being edited.
    FPreviousOrderTotal : Double;
    FPreviousLineTotal : Double;

    FServiceSet : Boolean;

    FFocusedControl: TWinControl;

    //PR: 06/10/2011 ABSEXCH-11767 New variables and functions to ensure that we don't update average costs
    // unless the line value has changed. Criteria for change are differences in value, StockCode/Location, Qty (+ PackQty), Qty Picked.
    FOriginalLineValue : Double;
    FOriginalLineQty : Double;
    FOriginalPickQty : Double;
    FOriginalStockCode : string;

    //PR: 16/03/2012 ABSEXCH-12399
    StockFormDisplayed : Boolean;

    // CJS 2016-01-18 - ABSEXCH-17102 - 4.5 - Intrastat on Transaction Line
    FLineState: TLineState;

    //PR: 15/11/2017 ABSEXCH-19451
    FAllowPostedEdit : Boolean;
    function TransactionViewOnly : Boolean;

    function GetLineValue : Double;
    function GetLineQty : Double;

    function LineValuesChanged : Boolean;
    function IsAverageCostMethod : Boolean;

    Function GetBadQty  :  Boolean;

    Procedure SetBadQty(A  :  Boolean);

    Property BadQty  :  Boolean read GetBadQty write SetBadQty;

    Function Current_Page  :  Integer;


    Procedure WMCustGetRec(Var Message  :  TMessage); Message WM_CustGetRec;

    Procedure Send_UpdateList(Edit   :  Boolean;
                              Mode   :  Integer);

    procedure BuildPageView;

    procedure PrimeExtList;

    Procedure ShuntExt;

    procedure BuildDesign;

    procedure SetUDFields(UDDocHed  :  DocTypes);

    procedure FormDesign;

    Function CheckNeedStore  :  Boolean;

    Procedure SetFieldFocus;

    Function ConfirmQuit  :  Boolean;

    Function ChkLinePwrd(DT     : DocTypes;
                         Mode   : Byte)  :  Boolean;

    procedure SetIdStore(EnabFlag,
                         VOMode  :  Boolean);

    Procedure OutDesc;

    Procedure Form2Desc;

    Procedure SetQtyMulTab;

    Function PackCost2Id(CP  :  Double)  :  Double;

    Function DisplayPackCost  :  Double;

    Function Edit_Cost(Idr     :  IDetail;
                       StockR  :  StockRec)  :  Boolean;

    Procedure OutIdGLDesc(GLCode  :  Str20;
                          OutObj  :  TObject);

    Procedure OutUserDef;

    Procedure Form2UserDef;

    Procedure OutId;

    procedure Form2Id;

    {$IFDEF SOP}
      Procedure MLoc_GenLocSplit(Fnum,
                                 Keypath:  Integer);

      procedure Update_LiveCommit(IdR     :  IDetail;
                                  DedMode :  SmallInt);

    {$ENDIF}

    Procedure Calc_LTot;

    procedure RefreshWiggle(Sender  :  TObject);

    procedure SetBtnTab(NewIndex  :  Integer);


    procedure StoreId(Fnum,
                      KeyPAth    :  Integer);

    procedure SetHelpContextIDs(bInc : boolean); // NF: 21/06/06

    {$IFDEF SOP}
    procedure ShowMultiBuyDiscounts;
    procedure ClearMultiBuyDiscounts;
    procedure UpdateMultiBuyDiscounts;
    procedure ShowOrHideAdditionalDiscountTotals(bShow : Boolean);
    procedure DiscountValueChange(Sender : TObject);
    procedure AddMultiBuyDescLines;
    {$ENDIF}
    function ServicePanelHeight(OffSet : Integer = 0) : Integer;
    procedure SetButtonTops;
    procedure SetFormHeight;
    procedure EnableECServiceCheckBox;

    procedure ProcessVATCode(Sender: TObject; Const CalledOnExit : Boolean);

    //PR: 08/02/2010 New functions for setting control positions
    procedure SetPanelTops;
    function PanelHeight(const oControl : TControl) : Integer;
    procedure ResetTabOrder;
    procedure SetCoreValues;

    //PR: 02/08/2012 ABSEXCH-12746
    function AllowPicking : Boolean;

    // CJS 2016-01-21 - ABSEXCH-17163 - Special Code QR available on Pxx transactions
    procedure ArrangeIntrastatComponents;

    // CJS 2016-01-14 - ABSEXCH-17102 - 4.5 - Intrastat on Transaction Line
    procedure PopulateIntrastatLists;
    procedure EnableIntrastat(Enable: Boolean);
    procedure ReadIntrastatFields;
    procedure WriteIntrastatFields;
    procedure SetDefaultIntrastatDetails;

  public
    { Public declarations }


    DefaultPage:  Integer;

    {$IFDEF SOP}
      CommitPtr  :  Pointer;

    {$ENDIF}

    ExLocal    :  TdExLocal;

    Procedure ChangePage(NewPage     :  Integer;
                         ForceChange :  Boolean);


    procedure ShowLink(InvR      :  InvRec;
                       VOMode    :  Boolean);

    procedure ProcessId(Fnum,
                        KeyPAth    :  Integer;
                        Edit,
                        InsMode    :  Boolean);

    procedure SetFieldProperties(Panel  :  TSBSPanel;
                                 Field  :  Text8Pt) ;

    procedure EditLine(InvR       :  InvRec;
                       Edit,
                       InsMode,
                       ViewOnly   :  Boolean);

    //PR: 23/08/2012 ABSEXCH-13333
    function LineTotalInBase : Double;

    //PR: 14/11/2017 ABSEXCH-19451
    procedure EnableEditPostedFields;

   //PR: 26/06/2009 Added this so that line form can tell that header is being edited.
    property TransBeingEdited : Boolean read FTransBeingEdited write FTransBeingEdited;

    //PR: 23/08/2012 ABSEXCH-13333 Keep track of original totals on order being edited.
    property PreviousOrderTotal : Double read FPreviousOrderTotal write FPreviousOrderTotal;
    property PreviousLineTotal : Double read FPreviousLineTotal write FPreviousLineTotal;
  end;

  // MH 06/11/2014 ABSEXCH-15798: Added Execution Mode so I can add validation in for the Edit of SDN lines
  enumCheckCompletedMode = (ccStoreLine=0, ccStoreHeader=1);

Procedure Set_IdFormMode(State  :  DocTypes);

// CJS 2014-09-08 - ABSEXCH-15513 - allow VAT Rate A on Services for Ireland
function ValidECServiceVATCode(ExLocal: TdExLocal): Boolean;

// MH 06/11/2014 ABSEXCH-15798: Added Execution Mode so I can add validation in for the Edit of SDN lines
Function CheckCompleted(      Edit,MainChk, BadQty, NegQtyChk : Boolean;
                              ExLocal   : TdExLocal;
                              ParentF   : TForm;
                              CUPtr     : Pointer;
                        Var   ShowMsg   : Boolean;
                        Var   MainStr   : Str255;
                        Const ExecMode  : enumCheckCompletedMode)  : Boolean;

//PR: 02/08/2012 ABSEXCH-12746
procedure DisplayCantPickWarning(CreditHold : Boolean);
//PR: 02/08/2012 ABSEXCH-12746
function AccountOnHold(CustR : CustRec) : Boolean;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}


Uses
  StockProc, // NF:
  ETStrU,
  ETMiscU,
  ETDateU,
  BtrvU2,

  BTSupU2,
  BTSupU3,
  ComnUnit,
  ComnU2,
  CurrncyU,
  BTKeys1U,
  CmpCtrlU,
  SBSComp2,
  VARRec2U,
  MiscU,
  SysU2,
  SysU3,

  SaleTx2U,

  {$IFDEF PF_On}

    InvLst2U,

  {$ENDIF}

  {$IFDEF STK}
    FIFOL2U,
    DiscU3U,

    {$IFDEF SOP}
       MLoc0U,
       StkIntU,
       PayF2U,

       {$IFDEF POST}
         PostingU,
       {$ENDIF}

      {$IFDEF WOP}
         WOPCT1U,
      {$ENDIF}
    {$ENDIF}

    {$IFDEF PF_On}

       CuStkA3U,
    {$ENDIF}
  {$ENDIF}


  {$IFDEF CU}
    Event1U,
    CustIntU,
    OInv,
  {$ENDIF}

  InvCTSuU,
  InvCT2Su,
  InvFSu2U,
  InvFSu3U,

  {$IFDEF Rp}
    RepInpTU,
  {$ENDIF}

  {$IFDEF VAT}
    GIRateU,
  {$ENDIF}

  PWarnU,

  ExThrd2U,
  GenWarnU,

  ThemeFix,

  PassWR2U,
  InvListU,

  CustomFieldsIntf,
  ApiUtil,

  Warn1U,

  // CJS 2014-09-01 - v7.x Order Payments - T111 - Edit SOR - Disable nominated TH/TL fields and buttons if payments detected
  {$IFDEF SOP}
    OrderPaymentsInterfaces,
    oOrderPaymentsTransactionInfo,
    oOrderPaymentsTransactionPaymentInfo,
    PaymentF,

    // MH 23/09/2014: Modified to share transaction tracker with customisation
    OrdPayCustomisation,

    //PR: 10/08/2015 ABSEXCH-16388 for function OrderIsFullyPaid
    OrderPaymentFuncs,
  {$ENDIF SOP}

  // CJS 2016-01-13 - ABSEXCH-17102 - 4.5 - Intrastat on Transaction Line
  {$IFNDEF EXDLL}
  IntrastatXML,
  CountryCodes,
  CountryCodeUtils,
  {$ENDIF}

  JobUtils,
  StrUtil,
  StrUtils;

{$R *.DFM}


const
  I_SPACER = 4; //vertical pixels between panels
  I_ROOM_FOR_BUTTONS = 42; //Allow room for buttons if no panels visible
  I_TABHEIGHT = 26; //Height of tabs on page control

  WEB_EXTENSIONS_SET = [PIN];

Var
  TransFormMode  :  DocTypes;
  {$IFDEF SOP}
  MBDFramesController : TMBDFramesController; //PR: 17/04/2009
  {$ENDIF}


(*** MH 02/09/2009: Reversed out change as Training felt this would cause lots of customers problems
//PR: 27/01/2009 Function to check if the line is a quote with a negative quantity
function NegativeQuote(const ExLocal : TdExLocal) : Boolean;
begin
  Result := (Inv.InvDocHed in [SQU, PQU]) and
            (Trim(ExLocal.LId.StockCode) <> '') and
            (ExLocal.LId.Qty < 0.00);
end;
***)

//PR: 02/08/2012 ABSEXCH-12746
procedure DisplayCantPickWarning(CreditHold : Boolean);
begin
  if CreditHold then
    msgBox('This order is on credit hold or exceeds the customer''s credit limit.'#10#10'It is not possible to pick any items.', mtWarning,
           [mbOK], mbOK, 'Transaction on Credit Hold')
  else
    msgBox('This account is on hold. It is not possible to pick any items.', mtWarning,
           [mbOK], mbOK, 'Account on Hold');
end;

//PR: 02/08/2012 ABSEXCH-12746
function AccountOnHold(CustR : CustRec) : Boolean;
begin
  Result := CustR.AccStatus = 2;
end;


{ ========= Exported function to set View type b4 form is created ========= }

Procedure Set_IdFormMode(State  :  DocTypes);

Begin
  If (State<>TransFormMode) then
    TransFormMode:=State;

end;


Function TTxLine.GetBadQty  :  Boolean;

Begin
  Result:=fBadQty or fBadPickQty;

end;

Procedure TTxLine.SetBadQty(A  :  Boolean);

Begin
  fBadQty:=A;

end;
Function TTxLine.Current_Page  :  Integer;
Begin

  Result:=pcLivePage(PAgeControl1);

end;


Procedure TTxLine.WMCustGetRec(Var Message  :  TMessage);

Var
  DPtr    :  ^Double;

  {$IFDEF SOP}
    StackQty  :  Double;
    OpoLineCtrl  :  TOpoLineCtrl;

  {$ENDIF}

Begin

  With Message do
  Begin


    Case WParam of

     175
         :  With PageControl1 do
              ChangePage(FindNextPage(ActivePage,(LParam=0),BOn).PageIndex,BOff);


     {$IFDEF SOP}
       212  :  Begin

                 DPtr:=Pointer(LParam);

                 Self.Enabled:=BOff;

                 TForm(Self.Owner).Enabled:=BOff;

                 Display_LocUse(Self,ExLocal.LId,ExLocal.LStock,DPtr^,TxAutoMLId);

                 Self.Enabled:=BOn;

                 With TForm(Self.Owner) do
                 Begin
                   Enabled:=BOn;
                   Show;
                 end;

                 Show;

                 Dispose(DPtr);
                 BeenInLocSplit:=BOn;

               end;

     {$ENDIF}

     1000    :  Begin
                  Begin
                    { A delayed call here is made so that any events within the page about to dissappear do not interupt the release handle event }
                    {
                      CJS 01/02/2011 - ABSEXCH-10181 - Removed the Release
                      Handles call, so that controls are not destroyed when
                      changing tabs.
                    }
                    // Release_PageHandleEx(PageControl1,PageControl1.Pages[LParam]);
                  end;

                end;

     {$IFDEF SOP}
       1100..1102
             :  Begin
                  New(OpoLineCtrl,Create(Pointer(LParam)));

                  try
                    With OpoLineCtrl^ do
                    Begin
                      If (MapToStkWarn) then
                      Case WParam of
                        1100  :  Begin
                                   If (OSetQty) and (OLineQty<>0.0) and (ExLocal.LInv.InvDocHed In PurchSplit) then
                                   Begin
                                     Id3UPriceF.Value:=Currency_ConvFT(OLineQty,OSetCurr,ExLocal.LInv.Currency,UseCoDayRate);
                                   end;
                                 end;
                        else     If (Id3SCodeF.Text<>OStockCode) then
                                 Begin

                                   StackQty:=Id3QtyF.Value;

                                   If (StackQty=0.0) then
                                     StackQty:=1.0;

                                   Id3SCodeF.OrigValue:=Id3SCodeF.Text;

                                   Id3SCodeF.Text:=OStockCode;

                                   Id3SCodeF.Modified:=BOn;


                                   Id3SCodeFExit(Id3SCodeF);

                                   If (OSetQty) and (OLineQty>0.0) then
                                   Begin
                                     Id3QtyF.Value:=(StackQty*OLineQty);

                                     Id3PQtyFExit(Id3PQtyF);
                                   end;
                                 end;
                      end; {Case..}

                    end;
                  finally
                    Dispose(OpoLineCtrl,Destroy);

                  end; {try..}

                end;

         1129  :  If (DocHed In PurchSplit) then
                  Begin {* Respond that we do not require the opo section *}

                    SendMessage(THandle(LParam),WM_CustGetRec,1129,0);

                  end;

     {$ENDIF}
         //PR: 16/03/2012 ABSEXCH-12399 Stock window was displayed so we need to set focus correctly in the Qty exit event.
         1130  :  StockFormDisplayed := True;
    end; {Case..}

  end;
  Inherited;
end;


Procedure TTxLine.ChangePage(NewPage     :  Integer;
                             ForceChange :  Boolean);


Begin

  If (Current_Page<>NewPage) or (ForceChange) then
  With PageControl1 do
  Begin
    LockWindowUpdate(Self.Handle);

    ActivePage:=Pages[NewPage];

    PageControl1Change(PageControl1);

    LockWindowUpdate(0);
  end; {With..}
end; {Proc..}



procedure TTxLine.ShowLink(InvR      :  InvRec;
                           VOMode    :  Boolean);

Var
  FoundCode  :  Str20;

begin
  ExLocal.AssignFromGlobal(IdetailF);


  ExLocal.LGetRecAddr(IdetailF);

  ExLocal.LInv:=InvR;

  With ExLocal,LId,LInv do
  Begin
    If (Cust.CustCode<>CustCode) then
      GetCust(Self,CustCode,FoundCode,IsACust(CustSupp),-1);

    AssignFromGlobal(CustF);


    {$IFDEF STK}
      If (Is_FullStkCode(StockCode)) and (Stock.StockCode<>StockCode) then
        GetStock(Self,StockCode,FoundCode,-1);
    {$ENDIF}

    AssignFromGlobal(StockF);

    Caption:=Pr_OurRef(LInv)+' Transaction Line';

    LViewOnly:=VOMode;

    If (Not JustCreated) then {* Rebuild design based on doc type *}
      DocHed:=TransFormMode;

    BuildDesign;

  end;
  EnableECServiceCheckBox;

  if FLineState in [lsAdd, lsInsert] then
    ExLocal.LResetRec(IDetailF);

  OutId;

  If (ExLocal.LastEdit) then {* Get desc lines if editing *}
  begin
    OutDesc;

    //Store Line total value
    FOriginalLineValue := GetLineValue;
    FOriginalLineQty := GetLineQty;
    FOriginalPickQty := ExLocal.LId.QtyPick;
    FOriginalStockCode := ExLocal.LId.StockCode + ExLocal.LId.MLocStk;
  end;


  JustCreated:=BOff;

end;



procedure TTxLine.BuildPageView;


Begin
  PageView[1]:=TDetCtrl.Create;

  try
    With PageView[1] do
    Begin
      AddVisiRec(Id3Panel,BOff);
      AddVisiRec(Id3SCodeF,BOff);
      AddVisiRec(Id3SBox,BOff);

      AddVisiRec(pnlService, Boff);

      AddVisiRec(pnlValues,BOff);
{      AddVisiRec(Id3PQtyF,BOff);
      AddVisiRec(Id3QtyF,BOff);
      AddVisiRec(Id3UPriceF,BOff);
      AddVisiRec(Id3DiscF,BOff);
      AddVisiRec(Id3LTotF,BOff);}
//      AddVisiRec(LineExtF1,BOff);
     {$IFDEF SOP}
      AddVisiRec(scrMultiBuy,BOff);
     {$ENDIF}
      AddVisiRec(Id3Panel3,BOff);
      AddVisiRec(LUD1F,BOff);
      AddVisiRec(LUD2F,BOff);
      AddVisiRec(LUD3F,BOff);
      AddVisiRec(LUD4F,BOff);

      //6.9 New Udf fields
      AddVisiRec(edtUdf5,  BOff);
      AddVisiRec(edtUdf6,  BOff);
      AddVisiRec(edtUdf7,  BOff);
      AddVisiRec(edtUdf8,  BOff);
      AddVisiRec(edtUdf9,  BOff);
      AddVisiRec(edtUdf10, BOff);

      AddVisiRec(pnlWebExtensions,BOff);

      {$IFDEF SOP} {v4.22 should not really be here, or visible on stock only versions}
          AddVisiRec(Id3LocF,BOff);
      {$ENDIF}


      AddVisiRec(OkCP1Btn,BOff);
      AddVisiRec(CanCP1Btn,BOff);
    end;


  except

    PageView[1]:=nil;
  end; {try..}


  PageView[2]:=TDetCtrl.Create;

  try
    With PageView[2] do
    Begin
      AddVisiRec(Id1Panel,BOff);
      AddVisiRec(Id1ItemF,BOff);
      AddVisiRec(Id1QtyF,BOff);
      AddVisiRec(Id1SBox,BOff);

      AddVisiRec(pnlService, Boff);

      AddVisiRec(Id1UPriceF,BOff);
      AddVisiRec(Id1DiscF,BOff);
      AddVisiRec(Id1LTotF,BOff);
//      AddVisiRec(LineExtF1,BOff);
      AddVisiRec(pnlValues,BOff);


      AddVisiRec(Id3Panel3,BOff);
      AddVisiRec(LUD1F,BOff);
      AddVisiRec(LUD2F,BOff);
      AddVisiRec(LUD3F,BOff);
      AddVisiRec(LUD4F,BOff);

      //6.9 New Udf fields
      AddVisiRec(edtUdf5,  BOff);
      AddVisiRec(edtUdf6,  BOff);
      AddVisiRec(edtUdf7,  BOff);
      AddVisiRec(edtUdf8,  BOff);
      AddVisiRec(edtUdf9,  BOff);
      AddVisiRec(edtUdf10, BOff);

      AddVisiRec(pnlWebExtensions,BOff);


      AddVisiRec(OkCP1Btn,BOff);
      AddVisiRec(CanCP1Btn,BOff);
    end;


  except

    PageView[2]:=nil;
  end; {try..}


  PageView[3]:=TDetCtrl.Create;

  try
    With PageView[3] do
    Begin
      AddVisiRec(Id3Panel,BOff);
      AddVisiRec(Id3SCodeF,BOff);
      AddVisiRec(Id3SBox,BOff);

      AddVisiRec(pnlService, Boff);
      AddVisiRec(scrMultiBuy,BOff);

      AddVisiRec(Id3Panel3,BOff);
      AddVisiRec(LUD1F,BOff);
      AddVisiRec(LUD2F,BOff);
      AddVisiRec(LUD3F,BOff);
      AddVisiRec(LUD4F,BOff);

      //6.9 New Udf fields
      AddVisiRec(edtUdf5,  BOff);
      AddVisiRec(edtUdf6,  BOff);
      AddVisiRec(edtUdf7,  BOff);
      AddVisiRec(edtUdf8,  BOff);
      AddVisiRec(edtUdf9,  BOff);
      AddVisiRec(edtUdf10, BOff);

      AddVisiRec(OkCP1Btn,BOff);
      AddVisiRec(CanCP1Btn,BOff);
    end;


  except

    PageView[3]:=nil;
  end; {try..}


  { ========= Assign Desc fields ======== }

  try
    With LineDesc.DescFields do
    Begin
      Case Defaultpage of

        0  :  Begin
                AddVisiRec(Id1Desc2F,BOff);
                AddVisiRec(Id1Desc3F,BOff);
                AddVisiRec(Id1Desc4F,BOff);
                AddVisiRec(Id1Desc5F,BOff);
                AddVisiRec(Id1Desc6F,BOff);
              end;
        1,2
           :  Begin
                AddVisiRec(Id3Desc2F,BOff);
                AddVisiRec(Id3Desc3F,BOff);
                AddVisiRec(Id3Desc4F,BOff);
                AddVisiRec(Id3Desc5F,BOff);
                AddVisiRec(Id3Desc6F,BOff);
              end;
      end; {Case..}
    end; {With..}
  except

    LineDesc.DescFields.Free;
    LineDesc.DescFields:=nil;

  end;{try..}
end; {Proc..}


procedure TTxLine.PrimeExtList;

Begin
  ExtList[1]:=Label81;
  ExtList[2]:=Id5JCodeF;
  ExtList[3]:=Label82;
  ExtList[4]:=Id5JAnalF;
  ExtList[5]:=VATCCLab3;
  ExtList[6]:=Id3VATF;
  ExtList[7]:=Id3CCF;
  ExtList[8]:=Id3DepF;
  ExtList[9]:=Label85;
  ExtList[10]:=Id3NomF;
  ExtList[11]:=GLDescF;
  ExtList[12]:=Id3CostLab;
  ExtList[13]:=Id3CostF;
  ExtList[14]:=Label83;
  ExtList[16]:=Id3LTF;
  ExtList[17]:=nil;
  ExtList[18]:=nil;
  ExtList[19]:=nil;
  ExtList[20]:=nil;
  ExtList[21]:=DelDateLab;
  ExtList[22]:=Id3DelF;

end;


Procedure TTxLine.ShuntExt;

Const
  ISBreak = 4;
  JCBreak = 13;

Var
  n,
  Gap  :  Integer;
Begin
 //PR: 12/06/2009 This was reducing the height of the drop down when some fields were missing - don't use for MBDs
  If (Not Id5JCodeF.Visible) then
  Begin
    Gap:=Id3VATF.Top-Id5JCodeF.Top;

    If (Gap>0) then
    Begin
      For n:=Succ(ISBreak) to High(ExtList) do
      If (Assigned(ExtList[n])) then
      Begin
        ExtList[n].Top:=ExtList[n].Top-Gap;

      end;
      {$IFNDEF SOP}
//      LineExtF1.ExpandedHeight:=LineExtF1.ExpandedHeight-Gap;
      {$ENDIF}
    end;
  end;

  If (Not Id3CostF.Visible) then
  Begin
    Gap:=Id3LTF.Top-Id3CostF.Top;

    If (Gap>0) then
    Begin
      For n:=Succ(JCBreak) to High(ExtList) do
      If (Assigned(ExtList[n])) then
      Begin
        ExtList[n].Top:=ExtList[n].Top-Gap;

      end;
      {$IFNDEF SOP}
//      LineExtF1.ExpandedHeight:=LineExtF1.ExpandedHeight-Gap;
      {$ENDIF}
    end;
  end;


end;



{ ========== Build runtime view ======== }

procedure TTxLine.BuildDesign;


begin


  {* Set Data Specific Info *}

  De4Page.TabVisible:=((DocHed In [SOR]) and (PChkAllowed_In(160))) or ((DocHed In [POR]) and (PChkAllowed_In(170)));

  {$IFDEF SOP}
    If (DocHed In PurchSplit) and (De4Page.TabVisible) then
    Begin
      De4Page.Caption:='Qty/Receive';
      SBSPanel8.Caption:='Receive/Write Off - This Time';
      PickLab.Caption:='Receive';
    end;
  {$ENDIF}

  //PR: 01/07/2009 Added check for adding transaction - if we're adding then we don't care about the highlighted line.
  {PR: 23/09/2009 Lack of brackets around second part of condition was allowing stock code to be visible on AutoTrans -
    if NOMAuto is False then StockCode Field should never be visible.}
  Id3SCodeF.Visible:= ExLocal.LInv.NomAuto and ((ExLocal.LId.KitLink<>ExLocal.LInv.FolioNum) or not ExLocal.LastEdit);
  Id3SCodeLab.Visible:=Id3SCodeF.Visible;

  If (JBCostOn and (ExLocal.LId.KitLink<>0) and (Not Is_FullStkCode(ExLocal.LId.StockCode))) then {* Hide on desc lines *}
  Begin
    Id5JCodeF.Visible:=BOff;
    Id5JAnalF.Visible:=BOff;
    Label81.Visible:=BOff;
    Label82.Visible:=BOff;
(*    {$IFNDEF SOP} //PR: 22/04/2009
    LineExtF1.FocusFirst:=Id3VATF;
    {$ELSE}
    if Id3PQtyF.Visible then
      LineExtF1.FocusFirst:=Id3PQtyF
    else
      LineExtF1.FocusFirst:=Id3QtyF;
    {$ENDIF} *)
  end;

  // CJS 2016-01-13 - ABSEXCH-17102 - 4.5 - Intrastat on Transaction Line
  // SSD Uplift is for Ireland only
  lblSSDUplift.Visible := (CurrentCountry = IECCode);
  edtSSDUplift.Visible := (CurrentCountry = IECCode);

  // CJS 2016-01-15 - ABSEXCH-17102 - 4.5 - Intrastat on Transaction Line
  // QR Codes and NoTc are UK only
  ArrangeIntrastatComponents;

  // CJS 2016-01-14 - ABSEXCH-17102 - 4.5 - Intrastat on Transaction Line
  PopulateIntrastatLists;

  PrimeExtList;
  ShuntExt;

end;

// CJS 2016-01-21 - ABSEXCH-17163 - Hide QR Code on Pxx transactions
procedure TTxLine.ArrangeIntrastatComponents;
var
  Offset: Integer;
begin
  {$IFNDEF EXDLL}
  // For Purchase transactions and for non-UK countries the QR code is not
  // valid, so hide this option.
  if (ExLocal.LInv.InvDocHed in PurchSplit) or (CurrentCountry <> UKCCode) then
  begin
    chkCountry.Visible := False;
    chkQRCode.Visible  := False;

    // Resize the Country drop-down to cover the gap.
    cbIntrastatCountry.Left := cbNoTc.Left;
    cbIntrastatCountry.Width := cbNoTc.Width;

    // Calculate the difference between the top of the Unit Weight control and
    // the Country drop-down, and move the NoTC list and SSD Uplift control
    // to match with this, covering the gap left by the QR Code check-box.
    // Add 1 to the offset, because the comboboxes are 1 pixel larger
    Offset := cbIntrastatCountry.Top - edtLineUnitWeight.Top + 1;
    cbNoTc.Top := cbIntrastatCountry.Top + Offset;
    edtSSDUplift.Top := cbNoTc.Top + Offset;

    // Do the same for the labels.
    Offset := lblGoodsToCountry.Top - lblLineUnitWeight.Top + 1;
    lblNoTc.Top := lblGoodsToCountry.Top + Offset;
    lblSSDUplift.Top := lblNoTc.Top + Offset;
  end;
  {$ENDIF}
end;

// CJS 2016-01-14 - ABSEXCH-17102 - 4.5 - Intrastat on Transaction Line
procedure TTxLine.PopulateIntrastatLists;
var
  i: Integer;
  Line: string;
begin
  {$IFNDEF EXDLL}
  cbNoTc.Items.Clear;
  for i := 0 to IntrastatSettings.NatureOfTransactionCodesCount - 1 do
  begin
    Line := IntrastatSettings.NatureOfTransactionCodes[i].Code + ' - ' +
            IntrastatSettings.NatureOfTransactionCodes[i].Description;
    cbNoTc.Items.Add(Line);
    cbNoTc.ItemsL.Add(Line);
  end;
  LoadCountryCodes(cbIntrastatCountry);
  // LoadCountryCodes only loads the codes into the main Items list, but we
  // need the Code + Description, so we will copy these from the ItemsL list.
  cbIntrastatCountry.Items.Assign(cbIntrastatCountry.ItemsL);
  {$ENDIF}
end;

procedure TTxLine.EnableIntrastat(Enable: Boolean);
begin
  lblCommodityCode.Enabled   := Enable;
  edtCommodityCode.Enabled   := Enable;
  lblStockUnits.Enabled      := Enable;
  edtStockUnits.Enabled      := Enable;
  lblLineUnitWeight.Enabled  := Enable;
  edtLineUnitWeight.Enabled  := Enable;
  lblGoodsToCountry.Enabled  := Enable;
  chkCountry.Enabled         := Enable;
  chkQRCode.Enabled          := Enable;
  cbIntrastatCountry.Enabled := Enable;
  lblNoTc.Enabled            := Enable;
  cbNoTc.Enabled             := Enable;
  lblSSDUplift.Enabled       := Enable;
  edtSSDUplift.Enabled       := Enable;
  if not chkCountry.Checked then
    cbIntrastatCountry.Enabled := False;
end;

procedure TTxLine.ReadIntrastatFields;
begin
  {$IFNDEF EXDLL}
  if (Trim(Id3SCodeF.Text) <> '') then
  begin
    chkOverrideIntrastat.Checked := ExLocal.LId.SSDUseLine;
    if ExLocal.LId.SSDUseLine then
    begin
      edtCommodityCode.Text := ExLocal.LId.SSDCommod;
      edtStockUnits.Value := ExLocal.LId.SSDSPUnit;
      edtLineUnitWeight.Value := ExLocal.LId.LWeight;
      if (ExLocal.LId.SSDCountry = 'QR') then
      begin
        chkQRCode.Checked := True;
        cbIntrastatCountry.ItemIndex := -1;
      end
      else
      begin
        chkCountry.Checked := True;
        cbIntrastatCountry.ItemIndex := ISO3166CountryCodes.IndexOf(ifCountry2, ExLocal.LId.SSDCountry);
      end;
      if (ExLocal.LId.tlIntrastatNoTc <> '') then
        cbNoTc.ItemIndex := FindCloseMatch(ExLocal.LId.tlIntrastatNoTc, cbNoTc.Items)
      else
        // CJS 2016-01-22 - Default NoTC to 10 on Transaction Headers & Lines
        // If there is no NoTc on the line, take it from the header instead
        cbNoTc.ItemIndex := IntrastatSettings.IndexOf(stNatureOfTransaction, ifCode, Format('%2d', [ExLocal.LInv.TransNat]));

      if CurrentCountry = IECCode then
        edtSSDUplift.Value := ExLocal.LId.SSDUplift;
    end;
  end
  else
  begin
    chkOverrideIntrastat.Checked := False;
    edtCommodityCode.Text := '';
    edtStockUnits.Value   := 0;
    edtLineUnitWeight.Value := 0;
    chkCountry.Checked := True;
    chkQRCode.Checked := False;
    cbIntrastatCountry.ItemIndex := -1;
    cbNoTc.ItemIndex := -1;
    edtSSDUplift.Value := 0;
  end;
  {$ENDIF}
end;

procedure TTxLine.WriteIntrastatFields;
begin
  {$IFNDEF EXDLL}
  if (Trim(Id3SCodeF.Text) <> '') then
  begin
    ExLocal.LId.SSDUseLine:= chkOverrideIntrastat.Checked;
    if ExLocal.LId.SSDUseLine then
    begin
      // MH 10/06/2016 2016-R2 ABSEXCH-17593: Trimmed Commodity Code to prevent validation error and
      // historically they were stored without padding
      ExLocal.LId.SSDCommod := Trim(edtCommodityCode.Text);
      ExLocal.LId.SSDSPUnit := edtStockUnits.Value;
      ExLocal.LId.LWeight   := edtLineUnitWeight.Value;

      if (chkQRCode.Checked) then
        ExLocal.LId.SSDCountry := 'QR'
      else if cbIntrastatCountry.ItemIndex > -1 then
        ExLocal.LId.SSDCountry := ISO3166CountryCodes.ccCountryDetails[cbIntrastatCountry.ItemIndex].cdCountryCode2
      else
        ExLocal.LId.SSDCountry := '';

      if cbNoTc.ItemIndex > -1 then
        ExLocal.LId.tlIntrastatNoTc := Copy(cbNoTc.Text, 1, 2)
      else
        ExLocal.LId.tlIntrastatNoTc := '';

      if CurrentCountry = IECCode then
        ExLocal.LId.SSDUplift := edtSSDUplift.Value;
    end
    else
    begin
      ExLocal.LId.SSDCommod := '';
      ExLocal.LId.SSDSPUnit := 0;
      // MH 29/06/2016 2016-R2 ABSEXCH-17626: Don't zero down the weight as it contains the default weight from the stock record
      //ExLocal.LId.LWeight := 0;
      ExLocal.LId.SSDCountry := '';
      ExLocal.LId.tlIntrastatNoTc := '';
      ExLocal.LId.SSDUplift := 0;
    end;
  end;
  {$ENDIF}
end;

// CJS 2016-01-15 - ABSEXCH-17102 - 4.5 - Intrastat on Transaction Line
// See also SetDefaultIntrastatDetails in CuStkT3U.pas, as these two
// routines should be kept in sync (although they are not similar enough to
// move into a common routine).
procedure TTxLine.SetDefaultIntrastatDetails;
var
  FoundCode: Str20;
begin
  {$IFNDEF EXDLL}
  if (Trim(Id3SCodeF.Text) <> '') then
  begin
    ExLocal.LId.SSDUseLine := chkOverrideIntrastat.Checked;
    if chkOverrideIntrastat.Checked then
    begin
      {$IFDEF STK}
      // Retrieve the Stock record
      if (Is_FullStkCode(ExLocal.LId.StockCode)) and (Stock.StockCode <> ExLocal.LId.StockCode) then
        GetStock(self, ExLocal.LId.StockCode, FoundCode, -1);
      ExLocal.AssignFromGlobal(StockF);

      // Copy the defaults from the Stock record
      edtCommodityCode.Text := Stock.CommodCode;
      edtStockUnits.Value := Stock.SuppSUnit;
      if ExLocal.LId.IdDocHed in SalesSplit then
        edtLineUnitWeight.Value := Stock.SWeight
      else
        edtLineUnitWeight.Value := Stock.PWeight;
      {$ENDIF}

      // Retrieve the Trader record
      If (Cust.CustCode <> ExLocal.LId.CustCode) then
        GetCust(self, ExLocal.LId.CustCode, FoundCode, IsACust(Cust.CustSupp), -1);
      ExLocal.AssignFromGlobal(CustF);

      // Default the Country Code to the Trader Country Code
      if Cust.acDefaultToQR and not (ExLocal.LInv.InvDocHed in PurchSplit) then
      begin
        chkQRCode.Checked := True;
        ExLocal.LId.SSDCountry := 'QR';
        cbIntrastatCountry.ItemIndex := -1;
      end
      else if (Trim(Cust.acCountry) <> '') then
      begin
        if (Cust.CustSupp = 'S') or (Trim(ExLocal.LInv.thDeliveryCountry) = '') then
          cbIntrastatCountry.ItemIndex := ISO3166CountryCodes.IndexOf(ifCountry2, Cust.acCountry)
        else
          cbIntrastatCountry.ItemIndex := ISO3166CountryCodes.IndexOf(ifCountry2, ExLocal.LInv.thDeliveryCountry);
      end;

      // CJS 2016-01-22 - Default NoTC to 10 on Transaction Headers & Lines
      cbNoTc.ItemIndex := IntrastatSettings.IndexOf(stNatureOfTransaction, ifCode, Format('%2d', [ExLocal.LInv.TransNat]));

    end;
    WriteIntrastatFields;
  end;
  {$ENDIF}
end;

//PR: 11/10/2011 Rewrote this procedure to deal with new custom fields for 6.9
procedure TTxLine.SetUDFields(UDDocHed  :  DocTypes);
begin
{$IFDEF ENTER1}
  //GS 24/11/2011 ABSEXCH-12078: modified the call to method 'DocTypeToCFCategory' to specify the 'transaction line' type
  //GS 09/12/2011 ABSEXCH-12273: set 'Arrage' default parameter to False, corrects UDF visibilty errors in certain situations
  EnableUdfs([UDF1L, UDF2L, UDF3L, UDF4L, lblUdf5, lblUdf6, lblUdf7, lblUdf8, lblUdf9, lblUdf10],
             [LUD1F, LUD2F, LUD3F, LUD4F, edtUdf5, edtUdf6, edtUdf7, edtUdf8, edtUdf9, edtUdf10],
             DocTypeToCFCategory(UDDocHed, True), False);

{$ENDIF}
end;

(*
procedure TTxLine.SetUDFields(UDDocHed  :  DocTypes);

Var
  PNo,n  :  Byte;

  UDAry,
  HDAry  :  Array[1..4] of Byte;

Begin
  PNo:=1;

  Case UDDocHed of
    {$IFDEF SOP}
      SOR,SDN  :  Begin
                    For n:=1 to 4 do
                      UDAry[n]:=14+n;

                    HDAry:=UDAry;
                  end;
      POR,PDN  :  Begin
                    For n:=1 to 4 do
                      UDAry[n]:=38+n;

                    HDAry:=UDAry;
                  end;
    {$ENDIF}
      SQU      :  Begin
                    PNo:=2;

                    For n:=1 to 4 do
                      UDAry[n]:=28+n;

                    HDAry:=UDAry;
                  end;
      PQU      :  Begin
                    PNo:=2;

                    For n:=1 to 4 do
                      UDAry[n]:=36+n;

                    HDAry:=UDAry;
                  end;

      else        Begin
                    If (UDDocHed In SalesSplit) then
                    Begin
                      PNo:=0;
                      UDAry[1]:=17;
                      UDAry[2]:=18;
                      UDAry[3]:=19;
                      UDAry[4]:=20;

                      HDAry[1]:=8;
                      HDAry[2]:=9;
                      HDAry[3]:=10;
                      HDAry[4]:=11;

                    end
                    else
                    Begin
                      For n:=1 to 4 do
                        UDAry[n]:=22+n;

                      HDAry:=UDAry;
                    end;

                  end;

  end; {Case..}

  UDF1L.Caption:=Get_CustmFieldCaption(PNo,UDAry[1]);
  UDF1L.Visible:=Not Get_CustmFieldHide(PNo,HDAry[1]);

  LUD1F.Visible:=UDF1L.Visible;

  UDF2L.Caption:=Get_CustmFieldCaption(PNo,UDAry[2]);
  UDF2L.Visible:=Not Get_CustmFieldHide(PNo,HDAry[2]);

  LUD2F.Visible:=UDF2L.Visible;


  UDF3L.Caption:=Get_CustmFieldCaption(PNo,UDAry[3]);
  UDF3L.Visible:=Not Get_CustmFieldHide(PNo,HDAry[3]);;

  LUD3F.Visible:=UDF3L.Visible;


  UDF4L.Caption:=Get_CustmFieldCaption(PNo,UDAry[4]);
  UDF4L.Visible:=Not Get_CustmFieldHide(PNo,HDAry[4]);

  LUD4F.Visible:=UDF4L.Visible;


end;

*)

procedure TTxLine.FormDesign;
const
  Spacer = 25;
  ExtraSpace = 16;
Var
  HideCC  :  Boolean;
  UseDec  :  Byte;

  ////PR: 13/10/2011 Variables to deal with new user fields for 6.9
  VisibleUDs : Integer;
  AnyOriginalUDVisible : Boolean;
  TopPartHeight : Integer; //Height of section which contains original udfs, depending upon which are visible.
  BottomPartHeight : Integer; //Height of section which contains new udfs, depending upon which are visible.
begin

  {* Set Version Specific Info *}

  Set_DefaultVAT(Id3VATF.Items,BOn,BOff);
  Set_DefaultVAT(Id3VATF.ItemsL,BOn,BOn);

  Set_DefaultDocT(Id3LTF.Items,BOff,BOff);
  Set_DefaultDocT(Id3LTF.ItemsL,BOff,BOff);


  HideCC:=BOff;

  pnlService.Visible := SyssVat.VatRates.EnableECServices;
  pnlService.Enabled := pnlService.Visible;
//  pnlWebExtensions.Visible := True;
  pnlWebExtensions.Visible := WebExtensionsOn and (Inv.InvDocHed in WEB_EXTENSIONS_SET);

  {$IFNDEF PF_On}

    HideCC:=BOn;

  {$ELSE}

    HideCC:=Not Syss.UseCCDep;
  {$ENDIF}

  Id3CCF.Visible:=Not HideCC;
  Id3DepF.Visible:=Not HideCC;

  If (HideCC) then {* Re-word labels *}
  Begin
    VATCCLab3.Caption:=CCVATName^;
  end
  else
  Begin
    VATCCLab3.Caption:=CCVATName^+VATCCLab3.Caption;
  end;

  Id1QtyF.DecPlaces:=Syss.NoQtyDec;
  Id3QtyF.DecPlaces:=Syss.NoQtyDec;
  Id3PQtyF.DecPlaces:=Syss.NoQtyDec;
  Id4QOF.DecPlaces:=Syss.NoQtyDec;
  Id4QDF.DecPlaces:=Syss.NoQtyDec;
  Id4QWF.DecPlaces:=Syss.NoQtyDec;
  Id4QOSF.DecPlaces:=Syss.NoQtyDec;
  Id4QPTF.DecPlaces:=Syss.NoQtyDec;
  Id4QWTF.DecPlaces:=Syss.NoQtyDec;

  Id3SCodeF.MaxLength:=StkKeyLen;

  {Id3NomF.MaxLength:=NomKeyLen;}

  If (JBCostOn) then
  Begin
    Id5JCodeF.MaxLength:=JobKeyLen;
    Id5JAnalF.MaxLength:=AnalKeyLen;
  end
  else
  Begin
    Id5JCodeF.Visible:=BOff;
    Id5JAnalF.Visible:=BOff;
    Label81.Visible:=BOff;
    Label82.Visible:=BOff;
(*    {$IFNDEF SOP} //PR: 22/04/2009
    LineExtF1.FocusFirst:=Id3VATF;
    {$ELSE}
    if Id3PQtyF.Visible then
      LineExtF1.FocusFirst:=Id3PQtyF
    else
      LineExtF1.FocusFirst:=Id3QtyF;
    {$ENDIF} *)
    {* Move up Ext fields here perhaps?*}
  end;

  SetUDFields(DocHed);
//PR: 13/10/2011 Added new user fields for 6.9
  VisibleUDs := NumberOfVisibleUDFs([edtUdf5, edtUdf6, edtUdf7, edtUdf8, edtUdf9, edtUdf10]);

  AnyOriginalUDVisible := LUD2F.Visible or LUD4F.Visible or LUD1F.Visible or LUD3F.Visible;

  Id3Panel3.Visible:= AnyOriginalUDVisible or (VisibleUDs > 0);

  if Id3Panel3.Visible then
  begin
    //Reduce height of panel according to which UDFs are visible - made more difficult because we
    //want to keep the original udfs separate from the new ones.
    if not AnyOriginalUDVisible then
    begin
      bevUdfs.Visible := False;
      TopPartHeight := 0
    end
    else
    begin
      If ((Not LUD2F.Visible) and (Not LUD4F.Visible)) or
         ((Not LUD1F.Visible) and (Not LUD3F.Visible)) then
         begin
           bevUdfs.Top := 37;
           TopPartHeight := 37;
         end
      else
        TopPartHeight := 63;
    end;

    if VisibleUDs >= 3 then
      BottomPartHeight := 3 * Spacer
    else
    if VisibleUDs = 2 then
      BottomPartHeight := 2 * Spacer
    else
    if VisibleUDs = 1 then
      BottomPartHeight := Spacer
    else
    begin
      BottomPartHeight := 0;
      TopPartHeight := 51;
      bevUdfs.Visible := False;
    end;

    Id3Panel3.Height := TopPartHeight + BottomPartHeight + ExtraSpace;


    //Reduce Width of UDF panel if either left 2 or right 2 udfs are both hidden and we have only one column of new udfs
    If (((Not LUD3F.Visible) and (Not LUD4F.Visible)) or ((Not LUD2F.Visible) and (Not LUD4F.Visible))) and
         (VisibleUDs < 4) then
    Begin
      Id3Panel3.Width:=Id3Panel3.Width-205;
      bevUdfs.Width := Id3Panel3.Width - 20;

    end;
  end;
  SetButtonTops;


  Id3CCF.MaxLength:=CustVATLen;
  Id3DepF.MaxLength:=CustVATLen;


  If (DocHed In PurchSplit) then
  Begin
    Id3CostLab.Caption:='Uplift';
    UseDec:=Syss.NoCosDec;
    Id3CostF.HelpContext:=740;
  end
  else
  Begin
    Id3CostLab.Caption:='Cost';
    UseDec:=Syss.NoNetDec;
  end;

  Id1UPriceF.DecPlaces:=UseDec;
  Id3UPriceF.DecPlaces:=UseDec;
  Id3CostF.DecPlaces:=Syss.NoCosDec;

  {* Hide cost if margin pwrd off *}
  Id3CostF.Visible:=Show_CMG(DocHed) {$IFNDEF LTE} or (DocHed In PurchSplit) {$ENDIF};

  Id3CostLab.Visible:=Id3CostF.Visible;

  Id3PQtyF.Visible:=Syss.InpPack;
  Id3PQLab.Visible:=Syss.InpPack;

  DE1Page.TabVisible:=(DefaultPage=0);
  DE2Page.TabVisible:=(DefaultPage=1);
  DE3Page.TabVisible:=(DefaultPage=2);
  {DE5Page.TabVisible:=JBCostOn;}

(*  If (DefaultPage=0) then
  With LineExtF1 do
  Begin
    OrigParent:=DE1Page;
    {$IFNDEF SOP}
    TabPrev:=Id1DiscF;
    {$ELSE}
    TabPrev:=Id3Desc6F;
    {$ENDIF}
  end;
*)

  {$IFDEF SOP}
    If (Syss.UseMLoc) then
    Begin
      If (Not Syss.InpPack) then
      Begin
        Id3LocLab.Left:=Id3PQLab.Left;
        Id3LocLab.Top:=Id3PQLab.Top;
        Id3LocLab.Parent:=Id3PQLab.Parent;
        Id3LocLab.Width:=Id3PQLab.Width;

        Id3LocF.Left:=Id3PQtyF.Left;
        Id3LocF.Top:=Id3PQtyF.Top;
        Id3LocF.TabOrder:=Id3PQtyF.TabOrder;

        Id3SCodeF.Width:=170;
        Id3SCodeF.PosArrows;

      end
      else
      Begin
        {With Id3SCodeLab do
        Begin
          WordWrap:=BOn;
          Width:=30;
          Height:=28;
          Top:=5;
        end;

        With Id3SCodeF do
        Begin
          Width:=132;
          Left:=39;
        end;

        With Id3LocLab do
        Begin
          Left:=176;
          Top:=12;
          Parent:=Id3PQLab.Parent;
        end;

        Id3LocF.Left:=203;
        Id3LocF.Top:=10;}

      end;
    end;
    {else
      Id3LocF.TabOrder:=Id3DelF.TabOrder;}


  {$ENDIF}

  If (Not (DocHed In PSOPSet)) then
      DelDateLab.Caption:='Line Date';

  {$IFDEF SOP}

  {$ELSE}
    {DelDateLab.Visible:=BOff;
    Id3DelF.Visible:=BOff;}
    Id3LocLab.Visible:=BOff;

  {$ENDIF}
  SetFormHeight;

  BuildDesign;

  ChangePage(DefaultPage,BOn);
end;


procedure TTxLine.FormActivate(Sender: TObject);
begin
  If (FormJustCreated) then
  Begin
    FormJustCreated:=BOff;

    {$IFDEF CU} {* Call hooks here *}
      GenHooks(4000,8,ExLocal);
    {$ENDIF}
  end;

  {$IFDEF SOP}
     OpoLineHandle:=Self.Handle;
  {$ENDIF}

end;


procedure TTxLine.FormCreate(Sender: TObject);
var
  i: Integer;
  Line: string;
begin
  // MH 12/01/2011 v6.6 ABSEXCH-10548: Modified theming to fix problem with drop-down lists
  ApplyThemeFix (Self);

  FTransBeingEdited := False;
  // NF: 21/06/06
  bHelpContextInc := FALSE;

  fFrmClosing:=BOff;

  ExLocal.Create;

  LineDesc:=TLineDesc.Create;
  LastLineDesc:=nil;

  {$IFDEF BoMObj}
    oLineBoMHelper := TLineBoMHelper.Create;
  {$ENDIF}

  InPassing:=BOff;
  InOutId:=BOff;

  HadDefLoc:=BOff;

  PassStore:=BOff;

  DelLnk:=BOff;

  NegQtyChk:=BOff;

  try
    With LineDesc do
    Begin
      Fnum:=IDetailF;
      Keypath:=IdFolioK;
    end;
  except

    LineDesc.Free;
    LineDesc:=nil;

  end;

  JustCreated:=BOn;


  FirstQty:=BOff;

  BadQty:=BOff;
  fBadPickQty:=BOff;

  LastQtyValue:=0;
  StkChkCnst:=1;
  LastPickValue:=0;

  {$IFDEF STK}
    DispStk:=nil;
  {$ENDIF}

  ClientHeight:=245;
  ClientWidth:=640;

  BeenInLocSplit:=BOff;

  DocHed:=TransFormMode;

  {$IFDEF SOP}
    DefaultPage:=2;

    TxAutoMLId:=nil;

    CommitPtr:=nil;
  {$ELSE}
    {$IFDEF STK}
      DefaultPage:=1;
    {$ELSE}
      DefaultPage:=0;
    {$ENDIF}
  {$ENDIF}


  With TForm(Owner) do
    Self.Left:=Left+2;

  If (Owner is TSalesTBody) then
    With TSalesTBody(Owner) do
      Self.SetFieldProperties(I1FPanel,I1AccF);



  BuildPageView;

  FormDesign;


  FormJustCreated:=BOn;

  // NF: 21/06/06
  SetHelpContextIDs(FALSE);
  SetHelpContextIDs(TRUE);

  {$IFDEF SOP}
  //PR: 17/04/2009
  OriginalTabNext := nil;

  {$ELSE}
  //PR: 22/04/2009 Position total fields
//   pnlValues.Parent := DE2Page;
//   pnlValues.Left := 254;
//   pnlValues.Top := 2;
//   pnlValues.Height := 134;
   lblOtherDiscounts.Visible := False;
(*
   {$IFDEF STK}
   LineExtF1.Left := 418;
   Id3Panel.Width := 412; //PR: 24/09/2009 Tidiness for Stock non-SPOP version
   {$ELSE}
   LineExtF1.Left := 408;
   {$ENDIF}
   LineExtF1.Width := 213;
   LineExtF1.OrigWidth := 213;
   LineExtF1.ExpandedWidth := 213;
   LineExtF1.FocusFirst := Id5JCodeF;

   //PR: 24/09/2009 Bodge to make Arrow visible after run-time resizing!!!
   LineExtF1.ArrowX := LineExtF1.ArrowX -1;
   LineExtF1.ArrowX := LineExtF1.ArrowX +1;
*)
   edtMultiBuy.Visible := False;
   edtTransDiscount.Visible := False;

   edtMultiBuy.Enabled := False;
   edtTransDiscount.Enabled := False;

   edtMultiBuy.TabStop := False;
   edtTransDiscount.TabStop := False;

   {$IFNDEF SOP}
   lblTransDiscount.Visible := False;
   lblMBDiscount.Visible := False;
   {$ENDIF}

{   Id5JCodeF.Left := 64;
   Id5JAnalF.Left := 64;
   Id3VatF.Left := 64;
   Id3NomF.Left := 64;
   Id3CostF.Left := 64;
   Id3LTF.Left := 64;
   Id3DelF.Left := 64;

   Id3CCF.Left := 107;
   Id3DepF.Left := 148;
   GLDescF.Left := 4;

   UseISCB.Left := 171;
   IntBtn.Left := 171;

   DelDateLab.Left := 11;
   Label86.Left := 132; //Intrastat
   Label84.Left := 130; //Override
   Label83.Left := 18; //Line Type
   Id3CostLab.Left := 24;
   Label85.Left := 21; //GL Code
   VATCCLab3.Left := 2;
   Label82.Left := 21; //Analysis Code;
   Label81.Left := 19; //Job Code;

   Id3PQtyF.Left := 305;
   Id3PQtyF.Top := 9;
   Id3QtyF.Left := 305;
   Id3QtyF.Top := 32;
   Id3UPriceF.Left := 305;
   Id3UPriceF.Top := 59;
   Id3DiscF.Left := 305;
   Id3DiscF.Top := 84;
   Id3LTotF.Left := 305;
   Id3LTotF.top := 109;
 }

  {$ENDIF}
  FServiceSet := False;  //This flag will be set if the user manually clicks the service check box
  FUnitPriceChanged := BOff;  // SSK 27/06/2017 2017-R1 ABSEXCH-13530 : flag to determine change in Unit Price


  //PR: 16/03/2012 ABSEXCH-12399
  StockFormDisplayed := False;

  {$IFNDEF EXDLL}
  cbNoTc.Items.Clear;
  for i := 0 to IntrastatSettings.NatureOfTransactionCodesCount - 1 do
  begin
    Line := IntrastatSettings.NatureOfTransactionCodes[i].Code + ' - ' +
            IntrastatSettings.NatureOfTransactionCodes[i].Description;
    cbNoTc.Items.Add(Line);
  end;
  {$ENDIF}
end;




procedure TTxLine.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  If (Not fFrmClosing) then
  Begin
    fFrmClosing:=BOn;

    Try
      GenCanClose(Self,Sender,CanClose,BOn);

      If (CanClose) then
        CanClose:=ConfirmQuit;

      If (CanClose) then
      Begin

        {$IFDEF CU} {* Call hooks here *}
          GenHooks(4000,7,ExLocal);
        {$ENDIF}

        Send_UpdateList(BOff,100);

      end;
    Finally
      fFrmClosing:=BOff;
    end;
  end
  else
    CanClose:=BOff;
end;

procedure TTxLine.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;


procedure TTxLine.FormDeactivate(Sender: TObject);
begin
  {If (Not ExLocal.InAddEdit) then
    PostMessage(Self.Handle,WM_Close,0,0);}
end;

procedure TTxLine.FormDestroy(Sender: TObject);

Var
  n  :  Byte;

begin
  ExLocal.Destroy;

  LineDesc.Destroy;

  {$IFDEF BoMObj}
  If Assigned(oLineBoMHelper) Then
    FreeAndNIL(oLineBoMHelper);
  {$ENDIF}


  If (Assigned(LastLineDesc)) then
  Begin
    LastLineDesc.Free;
    LastLineDesc:=nil;
  end;

  {$IFDEF SOP}
    If (Assigned(TxAutoMLId)) then
      Dispose(TxAutoMLId,Done);
  {$ENDIF}

  For n:=Low(PageView) to High(PageView) do
    If (PageView[n]<>nil) then
      PageView[n].Free;

  {$IFDEF SOP}
    If Assigned(MBDFramesController) then
      FreeAndNil(MBDFramesController);
  {$ENDIF}

end;



procedure TTxLine.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

procedure TTxLine.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

{ == Procedure to Send Message to Get Record == }

Procedure TTxLine.Send_UpdateList(Edit   :  Boolean;
                                  Mode   :  Integer);

Var
  Message1 :  TMessage;
  MessResult
           :  LongInt;

Begin
  FillChar(Message1,Sizeof(Message1),0);

  With Message1 do
  Begin
    MSg:=WM_CustGetRec;
    WParam:=Mode+100;
    LParam:=Ord(Edit);
  end;

  With Message1 do
  Begin
    If (Mode=10) then
      MessResult:=SendMEssage((Owner.Owner as TForm).Handle,Msg,WParam,LParam)
    else
      MessResult:=SendMEssage((Owner as TForm).Handle,Msg,WParam,LParam);
  end;

end; {Proc..}



procedure TTxLine.SetBtnTab(NewIndex  :  Integer);

Var
  Inum  :  Integer;

Begin
  Case NewIndex of

    {0  :  Inum:=Id1CostF.TabOrder;
    1  :  Inum:=Id2CostF.TabOrder;}
    0..2
       :  if pnlWebExtensions.Visible  then
            Inum := pnlWebExtensions.TabOrder
          else
          if Id3Panel3.Visible  then
            Inum := edtUdf10.TabOrder  //PR: 13/10/2011 Added new user fields for 6.9
          else
          if scrMultiBuy.Visible  then
            Inum := scrMultiBuy.TabOrder
          else
            Inum:=Id3DelF.TabOrder;
    3  :  Inum:=Id4QWTF.TabOrder;
    {4  :  Inum:=Id5JanalF.TabOrder;}
    else  Inum:=0;
  end; {Case..}


  OkCP1Btn.TabOrder:=Succ(Inum);
  CanCP1Btn.TabOrder:=Succ(OkCP1Btn.TabOrder);


end;


procedure TTxLine.RefreshWiggle(Sender  :  TObject);


Var
  n  :  Integer;

Begin
  If (Sender is TPageControl) and (IsWinNT) then
  With (Sender as TPageControl).ActivePage do
  Begin
    For n:=0 to Pred(ControlCount) do
    Begin
      If (Controls[n] is TCurrencyEdit) then
        TCurrencyEdit(Controls[n]).WiggleHeight;

    end;
  end; {With..}
end; {Proc..}


procedure TTxLine.PageControl1Change(Sender: TObject);

Const
  {$IFDEF STK}

    UseP  =  1;

  {$ELSE}

    UseP  =  2;

  {$ENDIF}

  PVTxLate  :  Array[0..4] of Byte = (2,1,1,3,1);

  TabTxLate :  Array[0..4] of Byte = (13,6,16,8,3);

Var
  NewIndex  :  Integer;
  i : Integer;
begin
  Form2Id; //PR: 10/02/2010 Store contents of UDFs, etc in ID record, as they were getting lost when moving between tabs.
  SetHelpContextIDs(FALSE); // NF: 21/06/06
  SetHelpContextIDs(TRUE); // NF: 21/06/06

  If (Sender is TPageControl) then
  With Sender as TPageControl do
  Begin
    NewIndex:=pcLivePage(Sender);

(*    If (Not LineExtF1.NewSetting) and (NewIndex>2) then {* Panel is open, so close it *}
        LineExtF1.ForceClose; *)

    Case NewIndex of

      0,2..3
         :  Begin
              If (PageView[PVTxlate[NewIndex]]<>nil) then
                PageView[PVTxlate[NewIndex]].SetVisiParent(ActivePage);

              Id3LocLab.Visible:=(NewIndex=2);
              Id3Panel.SendToBack;

              //PR: 21/04/2009 Changes to move Qty/Disc/Total fields into Extended Form
              {$IFDEF SOP}
//              Id3Panel2.Parent := pnlValues;
              i := 0;    //PR: 16/07/2009 Fix to set Tab Order correctly - can't leave gaps
              if Syss.UseMLoc and not Id3PQtyF.Visible then
              begin
                Id3LocF.Parent := pnlValues;
                Id3LocF.TabOrder := i;
                inc(i);
              end;
              Id3PQtyF.Parent := pnlValues;
              Id3PQtyF.TabOrder := i;
              Id3QtyF.Parent := pnlValues;
              Id3QtyF.TabOrder := i + 1;
              Id3UPriceF.Parent := pnlValues;
              Id3UPriceF.TabOrder := i + 2;
              Id3DiscF.Parent := pnlValues;
              Id3DiscF.TabOrder := i + 3;
              Id3LTotF.Parent := pnlValues;
              Id3LTotF.TabOrder := i + 4;
              edtMultiBuy.Parent := pnlValues;
              edtMultiBuy.TabOrder := i + 5;
              edtTransDiscount.Parent := pnlValues;
              edtTransDiscount.TabOrder := i + 6;
{              if Id5JCodeF.Visible then
              begin
                Id5JCodeF.TabOrder := 8;
                Id5JAnalF.TabOrder := 9;
              end;}
              {$ELSE}   //PR: 13/07/2009 Fix for Tab Order in Non-Stock & Non-SPOP versions
              //pnlValues.Parent := DE2Page;
                {$IFDEF STK}
                if Syss.UseMLoc and not Id3PQtyF.Visible then
                begin
                  Id3LocF.Parent := DE2Page;
                  Id3LocF.TabOrder := 4;
                end;
{                Id3PQtyF.Parent := DE2Page;
                Id3PQtyF.TabOrder := 5;
                Id3QtyF.Parent := DE2Page;
                Id3QtyF.TabOrder := 6;
                Id3UPriceF.Parent := DE2Page;
                Id3UPriceF.TabOrder := 7;
                Id3DiscF.Parent := DE2Page;
                Id3DiscF.TabOrder := 8;
                Id3LTotF.Parent := DE2Page;
                Id3LTotF.TabOrder := 9;
                edtMultiBuy.Parent := DE2Page;
                edtMultiBuy.TabOrder := 10;
                edtTransDiscount.Parent := DE2Page;
                edtTransDiscount.TabOrder := 11;}
                {$ELSE}
                SetCoreValues;
                Id3LocF.TabStop := False;
                Id3PQtyF.TabStop := False;
{                Id3QtyF.Parent := DE2Page;
                Id3QtyF.TabOrder := 4;}
                //PR: 24/09/2009 Set tab order for Service fields.
                if pnlService.Visible then
                  pnlService.TabOrder := 4;
{                Id3UPriceF.Parent := DE2Page;
                Id3UPriceF.TabOrder := 6;
                Id3DiscF.Parent := DE2Page;
                Id3DiscF.TabOrder := 7;
                Id3LTotF.Parent := DE2Page;
                Id3LTotF.TabOrder := 8;
                edtMultiBuy.Parent := DE2Page;
                edtMultiBuy.TabOrder := 9;
                edtTransDiscount.Parent := DE2Page;
                edtTransDiscount.TabOrder := 10;}

                {$ENDIF}
              {$ENDIF}
//              Id3Panel2.SendToBack;

              //PR: 28/08/2009 Hide EC Service fields on Pick tab
              //pnlService.Visible := SyssVat.VatRates.EnableECServices and (NewIndex <> 3);
              //pnlService.Enabled := SyssVat.VatRates.EnableECServices and (NewIndex <> 3);
            end;

      1  :  If (PageView[UseP]<>nil) then
              PageView[UseP].SetVisiParent(ActivePage);

      // CJS 2016-01-15 - ABSEXCH-17102 - 4.5 - Intrastat on Transaction Line
      // Intrastat page
      4 : begin
            // Move the OK & Cancel buttons to the Intrastat page and fix up
            // their tab order.
            OkCP1Btn.Parent := ActivePage;
            CanCP1Btn.Parent := ActivePage;
            OkCP1Btn.TabOrder:=Succ(edtSSDUplift.TabOrder);
            CanCP1Btn.TabOrder:=Succ(OkCP1Btn.TabOrder);

          end;

    end; {Case..}

  RefreshWiggle(Sender);
  {$IFDEF SOP}
//  Form2Id;
  UpdateMultiBuyDiscounts;
  {$ENDIF}
  if NewIndex = 2 then
  begin
    ResetTabOrder;
  end;
  SetBtnTab(NewIndex);

  end; {with..}
end;

procedure TTxLine.PageControl1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  AllowChange:=Not StopPageChange;

  If (AllowChange) then
  Begin
    { v4.30 A delayed call here is made so that any events within the page about to dissappear do not interupt the release handle event }
    { Otherwise if a direct call to Release_Pages is made, I found that something like the Qty exit event would fire up in the middle
      of the Release Resource event, corrupting the combo boxes, by placing a posting message here, you ensure the events are fired in the correct sequence }

    PostMessage(Self.Handle,WM_CustGetRec,1000,Current_Page);

  end;
end;


Function TTxLine.CheckNeedStore  :  Boolean;
Begin
  Result:=CheckFormNeedStore(Self);
end;


Procedure TTxLine.SetFieldFocus;

Begin
  With ExLocal do
    Case Current_Page of

      0
         :  Id1ItemF.SetFocus;

      // CJS 2014-09-01 - v7.x Order Payments - T111 - Edit SOR - Disable nominated TH/TL fields and buttons if payments detected
      1,2
         :  If (Id3SCodeF.Visible) and (Id3SCodeF.CanFocus) then
              Id3SCodeF.SetFocus
            else
              Id3Desc1F.SetFocus;


      3  :  Id4QPTF.SetFocus;

      {4  :  Id5JCodeF.SetFocus;}

    end; {Case&With..}

end; {Proc..}

procedure TTxLine.CanCP1BtnClick(Sender: TObject);
begin
  If (Sender is TButton) then
  With (Sender as TButton) do
  Begin
    If (ModalResult=mrOk) then
    Begin
      //PR: 15/10/2010 Set active control to ensure that exit event of current field fires. Fix for ABSEXCH-9706
      ActiveControl := OkCP1Btn;
      
      //Only store the record if focus hasn't been returned to dodgy field .
      if ActiveControl = OkCP1Btn then
        StoreId(IdetailF,CurrKeyPath^[IdetailF]);
    end
    else
      If (ModalResult=mrCancel) then
      Begin

        Begin
          Close;
          Exit;
        end;
      end;
  end; {With..}
end;



Function TTxLine.ConfirmQuit  :  Boolean;

Var
  MbRet  :  Word;
  TmpBo  :  Boolean;
  EditId :  IDetail;


Begin

  TmpBo:=BOff;
  {$B-}

  //PR: 15/11/2017 ABSEXCH-19451 Change to use TransactionViewOnly
  If (ExLocal.InAddEdit)and (Not IdStored)  and (CheckNeedStore) and (Not TransactionViewOnly) then

  {$B+}

  Begin
    If (Current_Page<>DefaultPage) then {* Force view of main page *}
      ChangePage(DefaultPage,BOff);

    mbRet:=MessageDlg('Save changes to '+Caption+'?',mtConfirmation,[mbYes,mbNo,mbCancel],0);

    DelLnk:=BOn;
  end
  else
    mbRet:=mrNo;

  Case MbRet of

    mrYes  :  Begin
                StoreId(IdetailF,CurrKeyPath^[IdetailF]);
                TmpBo:=(Not ExLocal.InAddEdit) or (PassStore);
              end;

    mrNo   :  With ExLocal do
              Begin
                If (LastEdit) and (Not LViewOnly) and (Not IdStored) then
                  Status:=UnLockMLock(IdetailF,LastRecAddr[IdetailF]);

                {$IFDEF STK}
                   {$B-}
                   If (Id3SCodeF.Text<>'') and (ExLocal.LStock.StockCode=FullStockCode(Id3SCodeF.Text)) and (DelLnk) and (Assigned(LineDesc)) and (LineDesc.HasDesc) {(LastId.StockCode<>FullStockCode(Id3SCodeF.Text))} then
                   {$B+}
                   Begin
                     AssignToGlobal(IdetailF);

                     Delete_Kit(ExLocal.LStock.StockFolio,0,ExLocal.LInv);

                     {* Attempt to refresh list *}

                     Send_UpdateList(BOff,30);

                   end;


                {$ENDIF}


                try
                  {$B-}
                  //PR: 15/11/2017 ABSEXCH-19451
                  If (LastEdit) and (Not TransactionViewOnly) and (Assigned(LastLineDesc)) and (LastLineDesc.BeenDeleted) and (DelLnk) then
                  Begin
                    EditId:=LId;
                    LSetDataRecOfs(IdetailF,LastRecAddr[IdetailF]); {* Retrieve record by address Preserve position *}

                    Status:=GetDirect(F[IdetailF],IdetailF,LRecPtr[IdetailF]^,CurrKeyPath^[IdetailF],0); {* Re-Establish Position *}

                    If (LId.LineNo>EditId.LineNo) then {During the edit it got renumbered..}
                    Begin
                      LastLineDesc.RenumberBy(LId.LineNo-EditID.LineNo);
                    end;

					// MH 02/11/2015 2016R1 ABSEXCH-16613: Re-instated SQL mod to improve performance when Exploding BoM's
                    LastLineDesc.StoreMultiLines(LId,LInv, False);
                    Send_UpdateList(BOff,30);

                  end;

                  {$B+}
                finally
                  LastLineDesc.Free;
                  LastLineDesc:=Nil;

                end;

                Send_UpdateList(BOff,20);


                TmpBo:=BOn;
              end;

    mrCancel
           :  Begin
                TmpBo:=BOff;
                SetfieldFocus;
              end;
  end; {Case..}


  ConfirmQuit:=TmpBo;
end; {Func..}


{ == Function to determine if unit price and nominal code should be edited ==}

{ == Mode 1 = Unit Price
          2 = Nom Code == }

Function TTxLine.ChkLinePwrd(DT     : DocTypes;
                             Mode   : Byte)  :  Boolean;

Begin
  Result:=BOff;

  If (DT In OrderSet) then
  Begin
    Case Mode of
      1   :  Result:=((DT In SalesSplit) and (PChkAllowed_In(258))) or
                     ((Not (DT In SalesSplit)) and (PChkAllowed_In(262)));
      2   :  Result:=((DT In SalesSplit) and (PChkAllowed_In(259))) or
                     ((Not (DT In SalesSplit)) and (PChkAllowed_In(263)));

    end;
  end
  else
  Begin
    Case Mode of
      1   :  Result:=((DT In SalesSplit) and (PChkAllowed_In(256))) or
                     ((Not (DT In SalesSplit)) and (PChkAllowed_In(257)));
      2   :  Result:=((DT In SalesSplit) and (PChkAllowed_In(260))) or
                     ((Not (DT In SalesSplit)) and (PChkAllowed_In(261)));

    end;
  end;

  ChkLinePWrd:=Result;
end;



procedure TTxLine.SetIdStore(EnabFlag,
                             VOMode  :  Boolean);

Var
  Loop  :  Integer;

Begin

  ExLocal.InAddEdit:=Not VOMode or FAllowPostedEdit;

  OkCP1Btn.Enabled:=Not VOMode or FAllowPostedEdit;

  For Loop:=0 to ComponentCount-1 do
  Begin
    If (Components[Loop] is Text8Pt) then
    with Text8Pt(Components[Loop]) do
    Begin
      If (Tag=1) then
        ReadOnly:= VOMode and not AllowPostedEdit;
    end
      else
        If (Components[Loop] is TEditDate) then
        Begin
          If (TEditDate(Components[Loop]).Tag=1) then
            TEditDate(Components[Loop]).ReadOnly:= VOMode;
        end
        else
          If (Components[Loop] is TEditPeriod) then
          Begin
            If (TEditPeriod(Components[Loop]).Tag=1) then
              TEditPeriod(Components[Loop]).ReadOnly:= VOMode;
          end
          else
            If (Components[Loop] is TCurrencyEdit) then
            Begin
              If (TCurrencyEdit(Components[Loop]).Tag=1) then
                TCurrencyEdit(Components[Loop]).ReadOnly:= VOMode;
            end
            else
              If (Components[Loop] is TBorCheck) then
              Begin
                If (TBorCheck(Components[Loop]).Tag=1) then
                  TBorCheck(Components[Loop]).Enabled:= Not VOMode;
              end
              else
                If (Components[Loop] is TSBSComboBox) then
                Begin
                  If (TSBSComboBox(Components[Loop]).Tag=1) then
                    TSBSComboBox(Components[Loop]).ReadOnly:= VOMode;
              end;
  end; {Loop..}

  With Id3SCodeF do {* Set stock code to readonly if inside auto doc *}
  Begin

    Id3SCodeFEnter(Id3SCodeF);

    ReadOnly:=(ReadOnly or (Not ExLocal.LInv.NomAuto));

    // MH 21/09/2009: Added the call to enable/disable the checkbox again as the above code was causing it to be enabled incorrectly
    EnableECServiceCheckBox;
  end;

  With ExLocal do
    If (InAddEdit) then   {* Apply password restrictions to certain fields *}
    Begin
      Id1UPriceF.ReadOnly:=Id1UPriceF.ReadOnly or Not ChkLinePWrd(ExLocal.LInv.InvDocHed,1);
      Id3NomF.ReadOnly:=Id3NomF.ReadOnly or Not ChkLinePWrd(ExLocal.LInv.InvDocHed,2);

      Id3UPriceF.ReadOnly:=Id1UPriceF.ReadOnly;

    end;

end;


{ ============== Display Id Record ============ }

Procedure TTxLine.OutDesc;

Var
  n  :  Integer;

Begin
  With ExLocal,LId,LineDesc do
  Begin

    If (Is_FullStkCode(StockCode)) then
      LDKitLink:=LStock.StockFolio
    else
      LDKitLink:=FolioRef;

    LDFolio:=FolioRef;

    Editing:=BOn;

    GetMultiLines(LastRecAddr[Fnum],BOn);

    SetDescFields;

  end;

end;


Procedure TTxLine.Form2Desc;

Var
  n,
  PrevCount,
  NowCount,
  noLines  :  Integer;

  FoundOk  :  Boolean;


Begin

  With LineDesc.DescFields do
  Begin

    noLines:=Pred(Count);
    PrevCount:=Linedesc.Count;  NowCount:=0;

    FoundOk:=BOn;

    While (noLines>=0) and (FoundOk) do
    Begin
      FoundOk:=EmptyKey(IdDescfRec(noLines).Text,DocDesLen);

      If (FoundOk) then
        Dec(noLines);

    end;

    For n:=0 to Pred(Count) do
    Begin
      If (n<=noLines) then
      Begin
        If (n>Pred(LineDesc.Count)) then
          LineDesc.AddVisiRec(IdDescfRec(n).Text,0,0)
        else
          LineDesc.IdRec(n)^.fLine:=IdDescfRec(n).Text;
      end
      else
      Begin
        If (noLines=-1) and (LineDesc.Count>0) then
        Begin
          If (n=0) then {We have no additional lines any more, but we used to, so get rid}
          Begin
            LineDesc.Clear;
            Break;
          end;
        end
        else           {EL: v5.71.001. Prev Count used as LineDesc.Count would keep decrementing upon deletion}
          If (n<=Pred({LineDesc.Count}PrevCount)) then
            LineDesc.Delete(Pred(LineDesc.Count));
      end;      
    end;

  end; {With..}

  With ExLocal,LId,LineDesc do
  Begin
    {* Delete any old lines first *}

    LDFolio:=LId.FolioRef;

    If (Not LastEdit) then {* Get folio here for non stock lines *}
    Begin
      If (Is_FullStkCode(StockCode)) then
        LDKitLink:=LStock.StockFolio
      else
        LDKitLink:=LId.FolioRef;
    end;

    If (LastEdit) or ((HasDesc) and (noLines>-1)) then {* Delete what was there first *}
    Begin
      If (Is_FullStkCode(StockCode)) then
        LDKitLink:=LStock.StockFolio;

      NowCount:=MaxCount;

      If (LastEdit) then {Only delete original qty}
        MaxCount:=PrevCount;

      GetMultiLines(LastRecAddr[Fnum],BOff);

      MaxCount:=NowCount;
    end;

	// MH 02/11/2015 2016R1 ABSEXCH-16613: Re-instated SQL mod to improve performance when Exploding BoM's
    StoreMultiLines(LId,LInv, LastIns);
  end; {With..}
end;


Procedure TTxLine.SetQtyMulTab;

Begin
  With ExLocal do
    If (Not LViewOnly) and (Is_FullStkCode(LId.StockCode)) then
    With Id3PQtyF, LStock do
    Begin
      TabStop:=Not DPackQty;
      ReadOnly:=DPackQty;
    end;
end;


Function TTxLine.DisplayPackCost  :  Double;

Begin
  With ExLocal,LId do
  Begin
    If (ShowCase) and (PrxPack) then
      Result:=CostPrice*QtyPack
    else
      Result:=CostPrice;

  end; {Func..}
end;


Function TTxLine.PackCost2Id(CP  :  Double)  :  Double;

Begin
  With ExLocal,LId do
  Begin
    If (ShowCase) and (PrxPack) then
      Result:=Round_Up(DivWChk(CP,QtyPack),Syss.NoCosDec)
    else
      Result:=CP;

  end; {Func..}
end;


Procedure TTxLine.OutIdGLDesc(GLCode  :  Str20;
                              OutObj  :  TObject);

Var
  FoundOk  :  Boolean;
  NomCode,
  FoundCode:  LongInt;
  FoundCode2
           :  Str20;

Begin
  {$B-}
  If (Assigned(OutObj)) and (OutObj is Text8Pt) then
  With Text8pt(OutObj) do
  Begin
    NomCode:=IntStr(Trim(GLCode));

    If (Nom.NomCode<>NomCode) and (NomCode<>0)then
      FoundOk:=GetNom(Self,Form_Int(NomCode,0),FoundCode,-1)
    else
      FoundOk:=(NomCode<>0);

    If (FoundOk) then
      Text:=Nom.Desc
    else
      Text:='';
  end;

  {$B+}
end;


Procedure TTxLine.OutUserDef;

Begin
  With ExLocal,LId do
  Begin
    LUD1F.Text:=LineUser1;
    LUD2F.Text:=LineUser2;
    LUD3F.Text:=LineUser3;
    LUD4F.Text:=LineUser4;

    //6.9 New Udfs
    edtUdf5.Text  := LineUser5;
    edtUdf6.Text  := LineUser6;
    edtUdf7.Text  := LineUser7;
    edtUdf8.Text  := LineUser8;
    edtUdf9.Text  := LineUser9;
    edtUdf10.Text := LineUser10;

  end; {With..}
end;

Procedure TTxLine.Form2UserDef;

Begin
  With ExLocal,LId do
  Begin
    LineUser1:=LUD1F.Text;
    LineUser2:=LUD2F.Text;
    LineUser3:=LUD3F.Text;
    LineUser4:=LUD4F.Text;

    //6.9 New Udfs
    LineUser5  := edtUdf5.Text;
    LineUser6  := edtUdf6.Text;
    LineUser7  := edtUdf7.Text;
    LineUser8  := edtUdf8.Text;
    LineUser9  := edtUdf9.Text;
    LineUser10 := edtUdf10.Text;

  end; {With..}
end;

// Copies the values from ExLocal.LId into the form components
Procedure TTxLine.OutId;
// CJS 2014-09-01 - v7.x Order Payments - T111 - Edit SOR - Disable nominated TH/TL fields and buttons if payments detected
{$IFDEF SOP}
var
  iOPTransactionPaymentInfo : IOrderPaymentsTransactionPaymentInfo;
{$ENDIF SOP}
Begin
  With ExLocal,LId do
  Begin

    InOutId:=BOn;

edtReference.Text := tlReference;
edtReceiptNo.Text := tlReceiptNo;
edtFromPostcode.Text := tlFromPostCode;
edtToPostCode.Text := tlToPostCode;

    Id1ItemF.Text:=Item;
    Id1QtyF.Value:=Qty;
    Id1Desc1F.Text:=Desc;
    Id1UPriceF.Value:=NetValue;

    Id1DiscF.Text:=PPR_PamountStr(Discount,DiscountChr);

    Id1LTotF.Value:=InvLTotal(LId,Syss.ShowInvDisc,(LInv.DiscSetl*Ord(LInv.DiscTaken)));
    Id3CCF.Text:=CCDep[BOn];
    Id3DepF.Text:=CCDep[BOff];

    Id3NomF.Text:=Form_BInt(NomCode,0);

    // SSK 29/05/2017 2017-R1 ABSEXCH-13530: changes for Inclusive VAT ('I')
    if (VATCode In VATSet) then
      if (VATCode = VATMCode) then
        Id3VATF.ItemIndex := GetVATIndex(VATICode)
      else if (VATCode in [VATEECCode, VATECDCode]) then  //AP 21/09/2017 2017-R1 ABSEXCH-19016 & ABSEXCH-19061
        Id3VATF.ItemIndex := GetVATCIndex(VATCode,Bon)
      else
        Id3VATF.ItemIndex := GetVATIndex(VATCode);

    Id3CostF.Value:=DisplayPackCost;

    OutIdGLDesc(Id3NomF.Text,GLDescF);

    Id3LocF.Text:=MLocStk;
    If Syss.EnableOverrideLocations And (DocHed In PurchSplit) And (Trim(ExLocal.LInv.thOverrideLocation) <> '') Then
    Begin
      Id3LocF.Enabled := False;
    End; // If Syss.EnableOverrideLocations And (DocHed In PurchSplit) And (Trim(ExLocal.LInv.thOverrideLocate) <> '')

    Id3DelF.DateValue:=PDate;

    Id3SCodeF.Text:=Strip('B',[#32],StockCode);
    Id3Desc1F.Text:=Desc;

    Id3PQtyF.Value:=QtyMul;
    Id3QtyF.Value:=Ea2Case(LId,LStock,Id1QtyF.Value);
    Id3UPriceF.Value:=Id1UPriceF.Value;
    Id3DiscF.Text:=Id1DiscF.Text;
    Id3LTotF.Value:=Id1LTotF.Value;

    Id3LTF.ItemIndex:=DocLTLink;

    {$IFDEF STK}

      Id4QOF.Value:=Ea2Case(LId,LStock,Qty);
      Id4QDF.Value:=Ea2Case(LId,LStock,QtyDel);
      Id4QWF.Value:=Ea2Case(LId,LStock,QtyWOff);
      Id4QOSF.Value:=Ea2Case(LId,LStock,Qty_OS(LId));

      Id4QPTF.Value:=Ea2Case(LId,LStock,QtyPick);
      Id4QWTF.Value:=Ea2Case(LId,LStock,QtyPWOFF);

      SetQtyMulTab;

    {$ENDIF}

    Id5JCodeF.Text:=Strip('B',[#32],JobCode);
    Id5JAnalF.Text:=Strip('B',[#32],AnalCode);

    OutUserDef;

    InOutId:=BOff;

    {$IFDEF SOP}
     edtMultiBuy.Text:=PPR_PamountStr(Discount2,Discount2Chr);
     edtTransDiscount.Text:=PPR_PamountStr(Discount3,Discount3Chr);
    {$ENDIF}

    EnableECServiceCheckBox;

    //PR: 20/08/2009 EC Service fields
    if pnlService.Visible and (chkService.Enabled Or ExLocal.LViewOnly) then
    begin
      chkService.Checked := ECService;
      if chkService.Checked then
      begin
        dtServiceStart.DateValue := ServiceStartDate;
        dtServiceEnd.DateValue := ServiceEndDate;
      end
      else
      begin
        dtServiceStart.DateValue := ExLocal.LInv.TransDate;
        dtServiceEnd.DateValue := ExLocal.LInv.TransDate;
      end;

// MH 08/09/2009: Don't want to automatically set Services on for useability purposes
//      if not LastEdit and LCust.EECMember and not FServiceSet then
//      begin
//        chkService.Checked := True;
//      end;
    end; //if pnlService.Visible

    // CJS 2014-09-01 - v7.x Order Payments - T111 - Edit SOR - Disable nominated TH/TL fields and buttons if payments detected
    {$IFDEF SOP}
      // MH 23/09/2014: Modified to share transaction tracker with customisation - they are
      // essentially doing the same thing and sharing the object eliminates any data access
      // overhead in the customisation
      // MH 06/11/2014 ABSEXCH-15798: Locked down Order Payments SDN to prevent value being changed
      // MH 02/06/2015 2015-R1 ABSEXCH-16475: Allow new lines to be added/inserted freely
      //If Not OrderPaymentsCustomisationTransactionTracker(ExLocal.LInv).cttCanEdit Or (ExLocal.LInv.thOrderPaymentElement = opeDeliveryNote) Then
      If (Not ExLocal.LViewOnly)
         And
         (
           // When Editing an Order Payment Order Line lock down the value fields, except for the Qty which can be increased, if there is a non-zero payment position against the line
           ((ExLocal.LInv.thOrderPaymentElement = opeOrder) And ExLocal.LastEdit And OrderPaymentsCustomisationTransactionTracker(ExLocal.LInv).cttLineHasPayments[ExLocal.LId.ABSLineNo])
           Or
           // For Order Payment Delivery Notes always lock down the line except for the Qty which can be reduced
           (ExLocal.LInv.thOrderPaymentElement = opeDeliveryNote)
         ) Then
      Begin
        // Edit Mode + Payments found for line OR it is an Order Payments Delivery Note
        // Disable controls
        Id3SCodeF.Enabled := False;
        Id3LocF.Enabled := False;    // MH: Locked down location as the price can come from the location
        Id3PQtyF.Enabled := False;   // MH: Locked down the Pack Qty
        // MH 02/06/2015 2015-R1 ABSEXCH-16475: Qty has to be editable for SOR's and SDN's
        Id3UPriceF.Enabled := False;
        Id3DiscF.Enabled := False;
        edtMultiBuy.Enabled := False;
        edtTransDiscount.Enabled := False;
        Id3VATF.Enabled := False;
      End; // If ...
    {$ENDIF}

    // CJS 2016-01-13 - ABSEXCH-17102 - 4.5 - Intrastat on Transaction Line
    // Show/hide Intrastat page
    // PKR. 24/02/2016. ABSEXCH-17322. Show Intrastat only for Full Stock System
    IntrastatPage.TabVisible := (Syss.IntraStat) and
                                (ExLocal.LId.IdDocHed in [SQU, SOR, SDN, SIN, SRI, SRF, SJI, SCR, SJC, PQU, POR, PDN, PIN, PPI, PRF, PJI, PCR, PJC]) and
                                (FullStkSysOn) and
                                (Trim(ExLocal.LId.StockCode) <> '');
    {$IFNDEF EXDLL}
    if Syss.Intrastat and (Trim(ExLocal.LId.StockCode) <> '') then
    begin
      // CJS 2016-01-13 - ABSEXCH-17102 - 4.5 - Intrastat on Transaction Line
      ReadIntrastatFields;
      EnableIntrastat(LId.SSDUseLine and not ExLocal.LViewOnly);
      if ExLocal.LViewOnly then
        chkOverrideIntrastat.Enabled := False;
      // CJS 2016-02-26 - ABSEXCH-17332 - Goods to Country label on transaction line
      if ExLocal.LId.IdDocHed in SalesSplit then
        lblGoodsToCountry.Caption := 'Goods to Country'
      else
        lblGoodsToCountry.Caption := 'Goods from Country';
    end
    else
      EnableIntrastat(False);

    {$ENDIF}

  end;

end;


function DiscountChanged(sDiscount : string; rDiscount : Real48) : Boolean;
var
  i : iNteger;
  DP : Byte;
begin
  Result := False;
  if Length(sDiscount) > 0 then
  begin
    sDiscount := Trim(sDiscount);
    if (Length(sDiscount) > 0) then
      if sDiscount[Length(sDiscount)] = '%' then
        Delete(sDiscount, Length(sDiscount), 1);

    sDiscount := Trim(sDiscount);

    i := Pos('.', sDiscount);
    DP := Length(sDiscount) - i;

    Result := Round_Up(StrToFloat(sDiscount), DP) <> Round_Up(rDiscount, DP);
  end;
end;

// Copies the values from the form components into ExLocal.LId
procedure TTxLine.Form2Id;

Begin
  With ExLocal,LId do
  Begin
    Case DefaultPage of

      0  :  Begin
              Item:=Id1ItemF.Text;
              Qty:=Id1QtyF.Value;
              Desc:=Id1Desc1F.Text;
              NetValue:=Id1UPriceF.Value;

              ProcessInputPAmount(Discount,DiscountChr,Id1DiscF.Text);
              {$IFDEF SOP}
              if ExLocal.LastEdit then //PR: 12/05/2009 Don't set these discounts from form when adding, as can lead to rounding problems.
              begin
                if DiscountChanged(edtMultiBuy.Text, Discount2) then
                  ProcessInputPAmount(Discount2,Discount2Chr,edtMultiBuy.Text);
                if DiscountChanged(edtTransDiscount.Text, Discount3) then
                  ProcessInputPAmount(Discount3,Discount3Chr,edtTransDiscount.Text);
              end;
              {$ENDIF}

              CCDep[BOn]:=FullCCDepKey(Id3CCF.Text);
              CCDep[BOff]:=FullCCDepKey(Id3DepF.Text);
              NomCode:=IntStr(Id3NomF.Text);

              With Id3VATF do
                if (ItemIndex>=0) then
                begin
                  If ((Items[ItemIndex][1]='I') and (VAT <> 0.00)) then     // SSK 07/06/2017 2017-R1 ABSEXCH-13530: changes for Inclusive VAT ('I')
                    VATCode := VATMCode
                  else
                    VATCode := Items[ItemIndex][1];
                end;

              CostPrice:=PackCost2Id(Id3CostF.Value);

              If (Id3LTF.ItemIndex>=0) then
                DocLTLink:=Id3LTF.ItemIndex;

              PDate:=Id3DelF.DateValue;


            end;

      1,2
         :  Begin
              tlReference := edtReference.Text;
              tlReceiptNo := edtReceiptNo.Text;
              tlFromPostCode := edtFromPostcode.Text;
              tlToPostCode := edtToPostCode.Text;

              Qty:=Case2Ea(LId,LStock,Id3QtyF.Value);

              QtyMul:=Id3PQtyF.Value;

              StockCode:=FullStockCode(Id3SCodeF.Text);

              Desc:=Id3Desc1F.Text;
              NetValue:=Id3UPriceF.Value;


              ProcessInputPAmount(Discount,DiscountChr,Id3DiscF.Text);
              {$IFDEF SOP}
              if ExLocal.LastEdit and TransBeingEdited then //PR: 12/05/2009 Don't set these discounts from form when adding, as can lead to rounding problems.
              begin
                //PR: 13/07/2009 As the MBD is only displayed to n dec places we need to check if it has changed or not
                if edtMultiBuy.CanUndo then
                  ProcessInputPAmount(Discount2,Discount2Chr,edtMultiBuy.Text);
                ProcessInputPAmount(Discount3,Discount3Chr,edtTransDiscount.Text);
              end;
              {$ENDIF}

              Case DefaultPage of

                1  :  Begin

                        CCDep[BOn]:=FullCCDepKey(Id3CCF.Text);
                        CCDep[BOff]:=FullCCDepKey(Id3DepF.Text);
                        NomCode:=IntStr(Id3NomF.Text);

                        With Id3VATF do
                          if (ItemIndex >= 0) then
                          begin
                            If (Items[ItemIndex][1]='I') then     // SSK 07/06/2017 2017-R1 ABSEXCH-13530: changes for Inclusive VAT ('I')
                              VATCode := VATMCode
                            else
                              VATCode := Items[ItemIndex][1];
                          end;

                        CostPrice:=PackCost2Id(Id3CostF.Value);


                        If (Id3LTF.ItemIndex>=0) then
                          DocLTLink:=Id3LTF.ItemIndex;

                        
                      end;
                2  :  Begin

                        CCDep[BOn]:=FullCCDepKey(Id3CCF.Text);
                        CCDep[BOff]:=FullCCDepKey(Id3DepF.Text);
                        NomCode:=IntStr(Id3NomF.Text);


                        With Id3VATF do
                          if (ItemIndex>=0) then
                          begin
                            If (Items[ItemIndex][1]='I') then     // SSK 07/06/2017 2017-R1 ABSEXCH-13530: changes for Inclusive VAT ('I')
                              VATCode := VATMCode
                            else
                              VATCode := Items[ItemIndex][1];
                          end;


                        CostPrice:=PackCost2Id(Id3CostF.Value);

                        {$IFDEF SOP}
                          MLocStk:=Full_MLocKey(Id3LocF.Text);
                        {$ELSE}
                          MLocStk:=Id3LocF.Text;

                        {$ENDIF}

                        PDate:=Id3DelF.DateValue;

                        If (Id3LTF.ItemIndex>=0) then
                          DocLTLink:=Id3LTF.ItemIndex;

                        QtyPick:=Case2Ea(LId,LStock,Id4QPTF.Value);
                        QtyPWOff:=Case2Ea(LId,LStock,Id4QWTF.Value);

                      end;
              end; {Case..}
            end;
    end; {Case..}

    JobCode:=FullJobCode(Id5JCodeF.Text);
    AnalCode:=FullJACode(Id5JAnalF.Text);

    Form2UserDef;

    //PR: 20/08/2009 EC Service Fields
    ECService := chkService.Checked;
    if ECService then
    begin
      ServiceStartDate := dtServiceStart.DateValue;
      ServiceEndDate := dtServiceEnd.DateValue;
    end
    else
    begin
      ServiceStartDate := LJVar(' ', 8);
      ServiceEndDate := LJVar(' ', 8);
    end;

    // CJS 2016-01-14 - ABSEXCH-17102 - 4.5 - Intrastat on Transaction Line
    {$IFNDEF EXDLL}
    if Syss.Intrastat then
      WriteIntrastatFields;
    {$ENDIF} // EXDLL

  end;{With..}
end; {PRoc..}



(*  Add is used to add Customers *)

procedure TTxLine.ProcessId(Fnum,
                            KeyPAth    :  Integer;
                            Edit,
                            InsMode    :  Boolean);

Var
  KeyS       :  Str255;

  OldId,
  TmpId      :  IDetail;

  CurrRLine,
  RecAddr    :  LongInt;


Begin

  Addch:=ResetKey;

  KeyS:='';

  IdStored:=BOff;

  Elded:=Edit;

  If (Edit) then
  Begin

    With ExLocal do
    Begin
      LSetDataRecOfs(Fnum,LastRecAddr[Fnum]); {* Retrieve record by address Preserve position *}

      Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

      Report_BError(Fnum,Status);

      If (Not TransactionViewOnly) then
        Ok:=LGetMultiRec(B_GetDirect,B_MultLock,KeyS,KeyPAth,Fnum,BOff,GlobLocked)
      else
        Ok:=BOn;

    end;


    If (Not Ok) or (Not GlobLocked) then
      AddCh:=Esc;
  end;



  If (Addch<>#27) then
  With ExLocal,LId do
  begin

    LastIns:=InsMode;


    If (Not Edit) then
    Begin

      { NOTE: Changes to this section should be applied to }
      {       TInvoiceLines.AddNewLine in oInv.Pas.        }

      CurrRLine:=Id.LineNo; {* this is correct, as LId not set on an insert *}

      LResetRec(Fnum);

      FolioRef:=LInv.FolioNum;

      DocPRef:=LInv.OurRef;

      IDDocHed:=LInv.InvDocHed;

      If (InsMode) and (CurrRLine>0) then  {* Do not allow insert on first blank line! *}
        LineNo:=CurrRLine
      else
        LineNo:=LInv.ILineCount;

      {* Set on all Lines *}

      ABSLineNo:=LInv.ILineCount;


      {$IFDEF STK}
        LineType:=StkLineType[IdDocHed];
      {$ENDIF}

      If (Not (IdDocHed In StkAdjSplit)) then
      Begin
        FirstQty:=BOn;

        Qty:=1;

        {$IFNDEF STK}

          QtyMul:=1;

        {$ENDIF}


      end
      else
      Begin

        PostedRun:=StkAdjRunNo;

        NomMode:=StkAdjNomMode;

        QtyMul:=1;

        QtyPack:=QtyMul;

      end;

      PriceMulX:=1.0;

      Currency:=LInv.Currency;

      CXRate:=LInv.CXRate;

      CurrTriR:=LInv.CurrTriR;

      PYr:=LInv.ACYr;
      PPr:=LInv.AcPr;


      {* Keep rate at posting used for COS *}

      COSConvRate:=SyssCurr^.Currencies[Currency].CRates[UseCoDayRate];

      Payment:=DocPayType[IdDocHed];

      If (Syss.AutoClearPay) then
        Reconcile:=ReconC;



      CustCode:=LInv.CustCode;

      NomCode:=LCust.DefNomCode;

      VATCode:=LCust.VATCode;
      VATIncFlg:=LCust.CVATIncFlg;

      {MLocStk:=GetCustProfileMLoc(LCust.DefMLocStk,'',0); Do not set here as other wise if its stock based, it never gets set}

      If (IdDocHed In OrderSet) or ((Syss.QUAllocFlg) and (IdDocHed In QuotesSet)) then
        PDate:=LInv.DueDate
      else
        PDate:=LInv.TransDate;

      {$IFDEF PF_On}


        {CCDep[BOn]:=LCust.CustCC;

        CCDep[BOff]:=LCust.CustDep;}

        With LCust do
          CCDep:=GetCustProfileCCDep(CustCC,CustDep,CCDep,0);


        If (JBCostOn) then
        Begin

          JobCode:=LInv.DJobCode;
          AnalCode:=LInv.DJobAnal;


          If (IdDocHed In PurchSplit-[PPY]) then {* Set Nominal Code *}
            NomCode:=Job_WIPNom(NomCode,JobCode,AnalCode,StockCode,MLocStk,CustCode);


        end;

        // If set copy in the Override Location from the header
        If Syss.EnableOverrideLocations And (IdDocHed In PurchSplit) And (Trim(ExLocal.LInv.thOverrideLocation) <> '') Then
        Begin
          MLocStk := ExLocal.LInv.thOverrideLocation;
        End; // If Syss.EnableOverrideLocations And (ExLocal.LInv.DocHed In PurchSplit) And (Trim(ExLocal.LInv.thOverrideLocation) <> '')

      {$ENDIF}

      // Update the form components with the record values
      OutId;

    end
    else
    Begin
      LastLineDesc:=TLineDesc.Create;

      try
        If (Assigned(LineDesc)) then {* Take a copy of the lines as they were *}
          LineDesc.AssignCopy(LastLineDesc);

      except
        LastLineDesc.Free;
        LastLineDesc:=nil;
      end;

    end;


    SetFieldFocus;

    LastId:=LId;

    If (Not Edit) then
      LastId.Qty:=0.0;

  end; {If Abort..}

  SetIdStore(BOn,ExLocal.LViewOnly);

end; {Proc..}



{ ====== Function to update line total, and set VAT code if none set ====== }

Procedure TTxLine.Calc_LTot;


Begin
  Form2Id;

  With ExLocal,LId do
  Begin


    Id1LTotF.Value:=InvLTotal(LId,Syss.ShowInvDisc,(LInv.DiscSetl*Ord(LInv.DiscTaken)));

    Id3LTotF.Value:=Id1LTotF.Value;

    If (Id1LTotF.Value<>0) and (Not (VATCode In VATSet)) then
    Begin

      VATCode:=LCust.VATCode;
      VATIncFlg:=LCust.CVATIncFlg;

      OutId;
    end;


    {* Don't call if nothing has changed, or if the line is still inclusive v4.31.004/build 124 *}

    If (VATCode In VATSet) and (VATCode<>VATICode) then
    Begin

      {$IFDEF CU} {* Call hooks here *}
        GenHooks(4000,26,ExLocal);
      {$ENDIF}

    end;

  end; {With..}
end; {Proc..}


procedure TTxLine.Id3SCodeFEnter(Sender: TObject);
begin
  {$IFDEF STK}
    If (Sender is Text8pt) then
    With (Sender as Text8pt), ExLocal do
    Begin
      If (Not EmptyKey(Text,StkKeyLen)) and (LId.DeductQty<>0.0) and (InAddEdit or LastEdit) then
      Begin
        //PR: 12/12/2017 ABSEXCH-19451 Previous way of checking this
        //was setting ReadOnly to False on posted transactions where
        //SerialyQty <> 0
        if (Round_Up(LId.SerialQty,2)<>0.0) then
          ReadOnly := True;

      end;
    end; {With..}
  {$ENDIF}
end;



procedure TTxLine.Id3SCodeFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  SetQtyOn,
  AltMod     :  Boolean;

  StoreQty   :  Double;



begin

  {$IFDEF STK}

    If (Sender is Text8pt) Then
    Begin
      With (Sender as Text8pt) do
      Begin
        AltMod:=Modified;  SetQtyOn:=BOff;

        FoundCode:=Text;

        {$IFDEF CU} {* Call hooks here *}
          StoreQty:=ExLocal.LId.Qty;

          Text:=TextExitHook(4000,15,Text,ExLocal);

          SetQtyOn:=(ExLocal.LId.Qty<>StoreQty) or (EnableCustBtns(4000,15));

          If (SetQtyOn) then {This hook can set the qty also here, but in so doing will not kick in any qty based events}
          Begin
            Id3QtyF.Value:=Ea2Case(ExLocal.LId,ExLocal.LStock,ExLocal.LId.Qty);
            StoreQty:=ExLocal.LId.Qty;
          End; // If (SetQtyOn)

          AltMod:=(AltMod or (FoundCode<>Text));
        {$ENDIF}

        FoundCode:=Strip('B',[#32],Text);

        // CJS 2014-10-09 - ABSEXCH-15670 - auto-tick or untick the EC Services
        // checkbox based on the Stock Item setting.

        // Untick the EC Service checkbox if the stock code was changed. If a
        // new Stock Code was entered, a further check below will tick/untick
        // the checkbox based on the IsService flag of the Stock Item.
        if AltMod and (ActiveControl <> CanCP1Btn) then
          chkService.Checked := False;

        If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>CanCP1Btn) then
        Begin

          StillEdit:=BOn;

          If (Trim(OrigValue)<>'') and (ExLocal.LStock.StockCode=FullStockCode(OrigValue)) then
          Begin
            ExLocal.AssignToGlobal(IdetailF);
            Delete_Kit(ExLocal.LStock.StockFolio,0,ExLocal.LInv);

            If (Assigned(LastLineDesc)) then
              LastLineDesc.BeenDeleted:=BOn;
          End; // If (Trim(OrigValue)<>'') and (ExLocal.LStock.StockCode=FullStockCode(OrigValue))

          FoundOk:=(GetsdbStock(Self.Owner,FoundCode,ExLocal.LInv.CustCode,FoundCode,ExLocal.LId.sdbFolio,3));

          If (FoundOk) then {* Credit Check *}
            With ExLocal do
            Begin
              AssignFromGlobal(StockF);
              SetQtyMulTab;
            End; // With ExLocal

          If (FoundOk) then
          Begin
            StopPageChange:=BOff;

            StillEdit:=BOff;

            Text:=FoundCode;

            With ExLocal,LId do
            Begin
              Form2Id;

              If ((OrigValue='') or (OrigValue<>Text)) and ((Not CheckNegStk) or (Not LastEdit)) then
              Begin
                If (Not SetQtyOn) then
                  Qty:=1;

                QtyMul:=1;
                QtyPack:=QtyMul;
              end // If ((OrigValue='') or (OrigValue<>Text)) and ((Not CheckNegStk) or (Not LastEdit))
              else
                If (CheckNegStk) then
                Begin
                  Qty:=0;
                  QtyMul:=1;
                  QtyPack:=QtyMul;
                  LastQtyValue:=0.0;
                  StkChkCnst:=0;
                End; // If (CheckNegStk)

              {$IFDEF SOP}
                SendSuperOpoStkEnq(FoundCode,MLocStk,LInv.CustCode,LInv.Currency,-1,0);
              {$ELSE}
                SendToObjectStkEnq(FoundCode,MLocStk,LInv.CustCode,LInv.Currency,-1,0);
              {$ENDIF}

              {$IFDEF BoMObj}

//If oLineBoMHelper.Active Then
//  oLineBoMHelper.Disable := (MessageDlg ('(' + IntToStr(LInv.FolioNum) + ') Use New function?', mtConfirmation, [mbYes, mbNo], 0) = mrNo);

                If oLineBoMHelper.Active Then
                Begin
                  oLineBoMHelper.UpdateBoMCache (ExLocal.LInv, ExLocal.LId, Stock, LineDesc, LCust);

//If (MessageDlg('Compare with MasterLine?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) Then
//  DebugTime := Now;

                End // If oLineBoMHelper.Active
                Else
              {$ENDIF}
                Begin
                  Link_StockCtrl(LId,LInv,LCust,1,0,0,Qty*QtyMul,1,LastIns,LineDesc);

//If (MessageDlg('Update MasterLine?', mtConfirmation, [mbYes, mbNo], 0) = mrYes) Then
//Begin
//  MasterInv := LInv;
//  MasterLine := LId;
//End; // If (MessageDlg('Update MasterLine?', mtConfirmation, [mbYes, mbNo], 0) = mrYes)

                  {* Attempt to refresh list *}

                  Send_UpdateList(BOff,30);
                End; // Else (?)

              {$IFDEF CU} {* Call hooks here *}
                GenHooks(4000,11,ExLocal);
              {$ENDIF}

              OutId;

              {$IFDEF SOP}
              //PR: 18/06/2009 Moved ShowMultiBuyDiscounts to here, as it was previously getting called even when cancelling.
                if (FoundCode <> '') and (ActiveControl<>CanCP1Btn) and not (TransBeingEdited and ExLocal.LastEdit) then
                begin
                  ShowMultiBuyDiscounts;
                  UpdateMultiBuyDiscounts; //PR: 27/04/2009
                End; // if (FoundCode <> '') and (ActiveControl<>CanCP1Btn) and not (TransBeingEdited and ExLocal.LastEdit)
              {$ENDIF}

              {$IFDEF SOP}
                HadDefLoc:=(Syss.UseMLoc) and (Id3LocF.Text<>'') and (Id3LocF.OrigValue='');
              {$ENDIF}
            End; // With ExLocal,LId

            {* Weird bug when calling up a list caused the Enter/Exit methods
                 of the next field not to be called. This fix sets the focus to the next field, and then
                 sends a false move to previous control message ... *}

            {FieldNextFix(Self.Handle);}

            //PR: Check for whether to enable EC Service check box.
            EnableECServiceCheckBox;

            // MH 08/09/2014 v7.1 ABSEXCH-15052: Check new Stock EC Service field to see if we
            //                                   should auto-tick the line service flag
            If chkService.Enabled And ExLocal.LStock.stIsService Then
            Begin
              chkService.Checked := True;
            End; // If chkService.Enabled And ExLocal.LStock.stIsService

            If pnlService.Enabled And chkService.Enabled And chkService.CanFocus Then
              chkService.SetFocus
            Else
            If (Not Syss.UseMLoc) then
            Begin
              If (Id3QtyF.CanFocus) then
              Begin
                Id3QtyF.SetFocus;
                Id3QtyF.SelectAll;
              end;
            end // If (Not Syss.UseMLoc)
            else
              If (Id3LocF.CanFocus) then
              Begin
                Id3LocF.SetFocus;
                Id3LocF.SelectAll;
              End; // If (Id3LocF.CanFocus)

            if Syss.Intrastat then
            begin
              if FLineState in [lsAdd, lsInsert] then
              begin
                // CJS 2016-01-15 - ABSEXCH-17102 - 4.5 - Intrastat on Transaction Line
                // We have a valid Stock Code, so we can now set the default
                // Intrastat details
                if Cust.acDefaultToQR then
                  chkOverrideIntrastat.Checked := True;
                // SetDefaultIntrastatDetails;
              end;
            end;

          end // If (FoundOk)
          else
          Begin
            StopPageChange:=BOn;
            SetFocus;

            //PR: Check for whether to enable EC Service check box.
            EnableECServiceCheckBox;
          end; // Else
        End // If ((AltMod) and (FoundCode<>'')) and (ActiveControl<>CanCP1Btn)
        else
        Begin
          If (OrigValue='') then
            With Exlocal,LId do
            Begin
              QtyMul:=1;
              Id3PQtyF.Value:=1;
              QtyPack:=QtyMul;

              {* Reset currently loaded stock record}
              LResetRec(StockF);
            End; // With Exlocal,LId

          //PR: Check for whether to enable EC Service check box.
          EnableECServiceCheckBox;
        End; // Else
      End; // With (Sender as Text8pt)
    End; // If (Sender is Text8pt)
  {$ENDIF}
end;


procedure TTxLine.Id3SCodeFDblClick(Sender: TObject);
begin
  {$IFDEF STK}

    With Id3SCodeF do
     If (CheckKey(FullStockCode(Text),ExLocal.LStock.StockCode,StkKeyLen,BOff)) then
    Begin
      If (Not MatchOwner('StockRec',Self.Owner.Owner)) then
      Begin

        If (DispStk=nil) then
          DispStk:=TFStkDisplay.Create(Self);

        try

          ExLocal.AssignToGlobal(StockF);

          With DispStk do

            Display_Account(0);

        except

          DispStk.Free;
          DispStk:=nil;
        end;
      end
      else  {* We are being called via StockRec, hence double click should inform custrec *}
      Begin
        Send_UpdateList(BOff,10);
      end;
    end
    else
      Id3SCodeFExit(Id3SCodeF);

  {$ENDIF}
end;



procedure TTxLine.Id3PQtyFEnter(Sender: TObject);
begin
  GenSelect:=Not InPassing;

  

  With ExLocal do
  Begin
    If (LastEdit) then
      LastQtyValue:=LastId.Qty*LastId.QtyMul*StkChkCnst
    else
      If (Not FirstQty) then
      Begin
        Form2Id;
        LastQtyValue:=LId.Qty*LId.QtyMul;
      end
      else
        FirstQty:=BOff;
  end;

  {$IFDEF CU}
    If (Not Id3QtyF.ReadOnly) and (Sender=Id3QtyF) then
    Begin
      Form2UserDef;

      Id3QtyF.Value:=ValueExitHook(4000,1,Id3QtyF.Value,ExLocal,DoFocusFix);
      Id3PQtyF.Value:=ValueExitHook(4000,2,Id3PQtyF.Value,ExLocal,DoFocusFix);

      OutUserDef;
    end;
  {$ENDIF}

  FFocusedControl := Sender as TWinControl;

end;


procedure TTxLine.Id3PQtyFExit(Sender: TObject);

Var
  Flg,
  FLowStk     :  Boolean;
  FoundCode   :  Str20;
  NewControl  :  TWinControl;
  bOK : Boolean;

begin
  // CJS 2016-04-14 - ABSEXCH-17416 - Insufficient Stock dialog appearing too late.
  // Changed bOK default value to True instead of False.
  bOK := True;
  FFocusedControl := nil;
  {* This line needed as other wise a phantom 'C' kept appearing in the discount...? *}
  If (Id1DiscF.Text='X') then
    MessageBeep(0);

  Begin
    Form2Id;

    FLowStk:=Boff;
    If (ActiveControl<>CanCP1Btn) and (GenSelect) then
    Begin
      {$IFDEF SOP}
        // MH 06/11/2014 ABSEXCH-15798: Prevent user increasing the SDN qty on lines derived
        // from the SOR, they can reduce it though to 'undeliver' stuff
        If (ExLocal.LInv.thOrderPaymentElement = opeDeliveryNote) And (ExLocal.LID.SOPLineNo <> 0) Then
        Begin
          BOK := (ExLocal.LId.Qty >= 0) And (ExLocal.LId.Qty <= ExLocal.LastId.Qty);
          If (Not bOK) Then
          Begin
            If Id3QtyF.CanFocus Then
              Id3QtyF.SetFocus;
            // MH 19/08/2015 2015-R1 ABSEXCH-16688: Modified text of error messages
            //MessageDlg ('The Quantity on this Order Payments Delivery Note Line must be in the range 0 to ' + Form_Real (ExLocal.LastId.Qty, 0, Syss.NoQtyDec), mtError, [mbOK], 0);
            MessageDlg ('The Quantity on this Delivery Note Line cannot be increased beyond ' + Form_Real (ExLocal.LastId.Qty, 0, Syss.NoQtyDec), mtError, [mbOK], 0);
          End; // If (Not bOK)
        End // If (LInv.thOrderPaymentElement = opeDeliveryNote) And (LID.SOPLineNo <> 0)
        // MH 02/06/2015 2015-R1 ABSEXCH-16475: Allow limited edit of paid Orders, if there is a payment
        // for the line then they can only increase the quantity, if no payments then no limitations
        Else If (ExLocal.LInv.thOrderPaymentElement = opeOrder) And OrderPaymentsCustomisationTransactionTracker(ExLocal.LInv).cttLineHasPayments[ExLocal.LId.ABSLineNo] Then
        Begin
          // Allow Qty to be increased only
          BOK := (ExLocal.LId.Qty >= ExLocal.LastId.Qty);
          If (Not bOK) Then
          Begin
            If Id3QtyF.CanFocus Then
              Id3QtyF.SetFocus;
            // MH 19/08/2015 2015-R1 ABSEXCH-16688: Modified text of error messages
            //MessageDlg ('The Quantity on this Order Payments Order Line must be >= ' + Form_Real (ExLocal.LastId.Qty, 0, Syss.NoQtyDec), mtError, [mbOK], 0);
            MessageDlg ('It is not possible to reduce the quantity on this Order line as a Refund may ' +
                        'be required, please use the Write Off option to reduce the quantity instead',
                        mtError, [mbOK], 0);
          End; // If (Not bOK)
        End // If (ExLocal.LInv.thOrderPaymentElement = opeOrder) And OrderPaymentsCustomisationTransactionTracker(ExLocal.LInv).cttLineHasPayments[ExLocal.LId.ABSLineNo]
        Else
      {$ELSE}
          BOK := True;
      {$ENDIF SOP}

      If BOK Then
      Begin
        With TCurrencyEdit(Sender),ExLocal,LId do
        Begin
      {$IFDEF CU} {* Call any pre store hooks here *}
        If (Not ReadOnly) then
          GenHooks(4000,3,ExLocal,DoFocusFix);
      {$ENDIF}


    {$IFDEF PF_On}

       If (Not EmptyKey(StockCode,StkKeyLen)) then
       Begin

         {If (EmptyKey(CCDep[BOn],ccKeyLen)) then v4.32 method
           CCDep[BOn]:=LCust.CustCC;

         If (EmptyKey(CCDep[BOff],ccKeyLen)) then
           CCDep[BOff]:=LCust.CustDep;}

         With LCust do
           CCDep:=GetCustProfileCCDep(CustCC,CustDep,CCDep,1);

         {If (EmptyKey(MLocStk,MLocKeyLen)) then v4.32 method
           MLocStk:=LCust.DefMLocStk;}

         MLocStk:=GetCustProfileMLoc(LCust.DefMLocStk,MLocStk,1);

         {$IFDEF STK}

           If (LastQtyValue<>Qty*QtyMul) then
           Begin

             Flg:=((Not LastEdit) and ((NetValue=0) or ((DocHed In PurchSplit) and (ExLocal.LId.sdbFolio=0))));

             Calc_StockPrice(LStock,LCust,LInv.Currency,Calc_IdQty(Qty,QtyMul,UsePack),LInv.TransDate,
                             NetValue,
                             Discount,DiscountChr,MLocStk,Flg,0);

             //PR: 16/06/2009 MBD calcs at this point were working on an unrounded NetValue which would become rounded
             //as soon as the user exited the Unit Price field, causing values to change even if there was no apparent
             //change in NetValue (Unit Price)
             NetValue := Round_Up(NetValue, Id3UPriceF.DecPlaces);

             {$IFDEF SOP}
               If (Flg) then
                 QBLineVAT_Update(ExLocal);
             {$ENDIF}

             If (IdDocHed In SalesSplit) and (Not LStock.ShowAsKit)  and (Is_FIFO(LStock.StkValType)) then
               CostPrice:=FIFO_GetCost(LStock,LInv.Currency,Qty*QtyMul,QtyMul,MLocStk);


             {$IFDEF CU} {* Call hooks here *}
                GenHooks(4000,12,ExLocal,DoFocusFix);
             {$ENDIF}

           end;

         {$ENDIF}


      end;

     {$ENDIF}

     If (NomCode=0) then
       NomCode:=LCust.DefNomCode;

    OutId; {* Set here, as otherwise, any auto discount does not get set *}

     If ((LastQtyValue<>Qty*QtyMul) or (BadQty)) and (KitLink=0)
        and (Not EmptyKey(StockCode,StkKeyLen)) then
     Begin


       {$IFDEF STK}
         If (LStock.StockCode<>StockCode) then
          Begin
            GetStock(Self,StockCode,Foundcode,-1);

            AssignFromGlobal(StockF);
          end
          else
            AssignToGlobal(StockF);


         If (Not LastEdit) then {* Don't keep checking on last Qty *}
           LastQtyValue:=0;

         If (LInv.InvDocHed In StkDedSet+StkAllSet) and (Syss.UseStock) then
         Begin
           NegQtyChk:=BOn;

           {Check_StockCtrl(StockCode,(Qty*QtyMul)-LastQtyValue,1,FLowStk,IdDocHed,LId,Self.Handle);
            Mode chaekc added for negative stock on invoices*}

           Check_StockCtrl(StockCode,(Qty*QtyMul)-LastQtyValue,1+Ord(CheckNegStk and (Not (IdDocHed In StkAllSet+StkOrdSet))),
                           FLowStk,IdDocHed,LId,Self.Handle);


           BadQty:=FLowStk;

           {$IFDEF SOP}
             If (Syss.UseMLoc) and (Assigned(TxAutoMLId)) then  {* Adjust quantity based on split *}
             Begin
               TxAutoMLId^.SetIdQty(LId);
               OutId;
             end;
           {$ENDIF}

           If (Not FLowStk) then
           Begin
             InPassing:=BOn;

             {$IFDEF SOP}
               If (Syss.UseMLoc) and (BeenInLocSplit) then
               Begin
                 FieldNextFix(Self.Handle,ActiveControl,Sender);
                 BeenInLocSPlit:=BOff;
               end
               else
             {$ENDIF}
               //PR: 16/03/2012 ABSEXCH-12399 If the Stock form has been shown, need to reset focus to the active control.
               //Don't use EL's FieldNextFix as using that somehow causes ActiveControl enter event to be called twice.
               if StockFormDisplayed then
               begin
                 if Assigned(ActiveControl) then
                   PostMessage(ActiveControl.Handle,wm_SetFocus,0,0);
                 StockFormDisplayed := False;
               end;



             InPassing:=BOff;
           end;
         end;

       {$ENDIF}


       If (FLowStk) and (CanFocus) then {* Force adjustment *}
         SetFocus;
     end;

        End; // With TCurrencyEdit(Sender),ExLocal,LId
      End; // If BOK
    End; // If (ActiveControl<>CanCP1Btn) and (GenSelect)

    Calc_LTot;

   {$IFDEF SOP}
    UpdateMultiBuyDiscounts; //PR: 27/04/2009
   {$ENDIF}
  end;
end;


procedure TTxLine.Id3DiscFoldEnter(Sender: TObject);
begin
  Begin

    Form2Id;

    With ExLocal,LId do
    Begin
      If (Discount=0) and (Id1LTotF.Value<>0) and (DiscountChr=C0)
                          and (EmptyKey(StockCode,StkKeyLen)) then
      Begin

        Discount:=LCust.Discount; DiscountChr:=LCust.CDiscCh;

      end;
    end; {With..}


    OutId;
  end;
  FFocusedControl := nil;
end;


procedure TTxLine.Id3DiscFoldExit(Sender: TObject);
begin
  Begin
    FFocusedControl := nil;
    Form2Id;


      If (Sender is Text8Pt) then
      With ExLocal,LId,Text8pt(Sender) do
      Begin
        If (Modified) then
        Begin


          {$IFDEF STK}
            If (Not EmptyKey(StockCode,StkKeyLen))
            and (LInv.InvDocHed In SalesSplit) then
            Begin

              If (DiscountChr In StkBandSet) then
                NetValue:=Get_StkPrice(LStock.SaleBands,Discount,DiscountChr,LInv.Currency,LStock.SellUnit,
                                       QtyMul,UsePack);

              {*EL: v6.01 Additional check added to see if discount will take line total below cost as well. Only triggered if value of discount modified. *}
              Check_LowCost(LId,LInv,LStock);


            end;
          {$ENDIF}

          {$IFDEF CU} {* Call any pre store hooks here *}
            If (Not ReadOnly) then
              GenHooks(4000,4,ExLocal,DoFocusFix);
          {$ENDIF}


          OutId;
        end;
      end; {With..}


    Calc_LTot;

   {$IFDEF SOP}
    UpdateMultiBuyDiscounts; //PR: 27/04/2009
   {$ENDIF}

  end;
end;

procedure TTxLine.Id3UPriceFEnter(Sender: TObject);
begin
  {* Also ised by any validated control with no on enter routine of it own *}

  GenSelect:=Not InPassing;

  {$IFDEF CU} {* Call any pre store hooks here *}
    {$B-}
    If (Sender is TCurrencyEdit) and (Not TCurrencyEdit(Sender).ReadOnly) and ((Sender=Id3UPriceF) or (Sender=Id1UPriceF)) then
    Begin
    {$B+}
      Form2Id;

      GenHooks(4000,9,ExLocal,DoFocusFix);

      OutId;
    end;
  {$ENDIF}

  FFocusedControl := Sender as TWinControl;
end;

procedure TTxLine.Id3UPriceFExit(Sender: TObject);
var
  lNetValue: Real;

begin
  FFocusedControl := nil;

  If ((Sender=Id3UPriceF) or (Sender=Id1UPriceF)) and (ActiveControl<>CanCP1Btn) and (GenSelect) then
  With ExLocal,LId do
  Begin

    lNetValue := NetValue;
    Form2Id;

    {$IFDEF CU} {* Call any pre store hooks here *}
      {$B-}
      If (Sender is TCurrencyEdit) and (Not TCurrencyEdit(Sender).ReadOnly) then
      {$B+}
        GenHooks(4000,5,ExLocal,DoFocusFix);
    {$ENDIF}

    // SSK 19/06/2017 2017-R1 ABSEXCH-13530: if the unit price of a vat inclusive transaction is changed pop this message up
    if (Sender=Id3UPriceF) and ((VATCode=VATICode) or (VATCode=VATMCode)) then
    begin
      
      FUnitPriceChanged := Round_Up((abs(lNetValue - Id3UPriceF.Value)), 2)>0.00;

      if FUnitPriceChanged then
      begin
        MessageDlg('You have edited the Unit Price of a VAT Inclusive transaction,' + #13
                    + 'please reselect the VAT code', mtInformation, [mbOk], 0);

        With Id3VATF do
        begin
          if CanFocus then SetFocus;
          SendMessage(handle, CB_SHOWDROPDOWN, Integer(True), 0);
        end;
      end;
    end;

    If (VATCode=VATICode) then
    Begin
      CalcVATExLocal(ExLocal,BOff,nil);

      {CalcVat(LId,LInv.DiscSetl);}

      OutId;
    end;

    {$IFDEF STK}
      If {(NetValue<CostPrice) and} (IdDocHed In SalesSplit)
      and (Is_FullStkCode(StockCode)) then
      Begin

        Check_LowCost(LId,LInv,LStock);

        {InPassing:=BOn;

        FieldNextFix(Self.Handle,ActiveControl,Sender);

        InPassing:=BOff;}

      end;
    {$ENDIF}

  end;

  Calc_LTot;
   {$IFDEF SOP}
    UpdateMultiBuyDiscounts; //PR: 27/04/2009
   {$ENDIF}
end;

  { ====== Function to determine if CP editable ====== }

  Function TTxLine.Edit_Cost(Idr     :  IDetail;
                             StockR  :  StockRec)  :  Boolean;

  Begin
    {$IFDEF STK}
      With IdR do
        Edit_Cost:=(((IdDocHed In SalesSplit)
               and (Not Is_FIFO(StockR.StkValType))
               and (Not Is_SerNo(StockR.StkValType)))
               or (IdDocHed In PurchSplit+QuotesSet)
               or  (EmptyKey(StockCode,StkKeyLen)));
    {$ENDIF}
  end; {Func..}


procedure TTxLine.Id3CostFDeleteMeEnter(Sender: TObject);
begin
  FFocusedControl := Sender as TWinControl;
  With ExLocal do
  Begin
    {$IFDEF STK}
      If (InAddEdit) and (Sender=Id3CostF) then
      Begin
        Form2Id;

        //PR: 21/12/2017 ABSEXCH-19451
        if not ExLocal.LViewOnly then
          Id3CostF.ReadOnly:=Not Edit_Cost(LId,Stock);

      end;
    {$ENDIF}  
  end;
end;


procedure TTxLine.Id3NomF2Exit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  FoundLong  :  LongInt;

  BalNow     :  Double;


begin
  FFocusedControl := nil;
  Begin
    Form2Id;

    If (Sender is Text8pt) then
    With (Sender as Text8pt) do
    Begin
      AltMod:=Modified;

      FoundCode:=Strip('B',[#32],Text);

      BalNow:=ExLocal.LId.NetValue;

      If (ExLocal.LId.DiscountChr=#0) then
        BalNow:=BalNow-ExLocal.LId.Discount;


      If ((AltMod) or (FoundCode='')) and (ActiveControl<>CanCP1Btn) and (ActiveControl<>OkCP1Btn)
          and (BalNow<>0.00) and (GenSelect) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetNom(Self.Owner,FoundCode,FoundLong,2));

        If (FoundOk) then {* Credit Check *}
        With ExLocal do
        Begin

          AssignFromGlobal(NomF);

          
        end;


        If (FoundOk) then
        Begin

          StopPageChange:=BOff;

          StillEdit:=BOff;

          Text:=Form_Int(FoundLong,0);

          {* Weird bug when calling up a list caused the Enter/Exit methods
               of the next field not to be called. This fix sets the focus to the next field, and then
               sends a false move to previous control message ... *}

          InPassing:=BOn;

          {FieldNextFix(Self.Handle,ActiveControl,Sender);}

          InPassing:=BOff;

          OutIdGLDesc(Text,GLDescF);

        end
        else
        Begin
          StopPageChange:=BOn;

          SetFocus;
        end; {If not found..}
      end;


    end; {with..}
  end;
end;

procedure TTxLine.Id1CCFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;

  IsCC       :  Boolean;

  BalNow     :  Double;


begin
  FFocusedControl := nil;
  {$IFDEF PF_On}

    Begin
      Form2Id;

      If (Sender is Text8pt) then
      With (Sender as Text8pt) do
      Begin
        FoundCode:=Name;

        IsCC:=Match_Glob(Sizeof(FoundCode),'CC',FoundCode,FoundOk);

        {$IFDEF CU} {* Call hooks here *}
          Text:=TextExitHook(4000,16+Ord(Not Iscc),Text,ExLocal,DoFocusFix);
        {$ENDIF}



        AltMod:=Modified;

        FoundCode:=Strip('B',[#32],Text);

        BalNow:=ExLocal.LId.NetValue;

        If (ExLocal.LId.DiscountChr=#0) then
          BalNow:=BalNow-ExLocal.LId.Discount;

        If ((AltMod) or (FoundCode='')) and (ActiveControl<>CanCP1Btn) and (ActiveControl<>OkCP1Btn)
            and (LComplete_CCDep(ExLocal.LId,BalNow)) and (Syss.UseCCDep) {and (GenSelect)} then
        Begin

          StillEdit:=BOn;

          FoundOk:=(GetCCDep(Self.Owner,FoundCode,FoundCode,IsCC,2));

          If (FoundOk) then {* Credit Check *}
          With ExLocal do
          Begin

            AssignFromGlobal(PWrdF);

          end;


          If (FoundOk) then
          Begin

            StopPageChange:=BOff;

            StillEdit:=BOff;

            Text:=FoundCode;

            InPassing:=BOn;

            {FieldNextFix(Self.Handle,ActiveControl,Sender);}

            InPassing:=BOff;

          end
          else
          Begin
            StopPageChange:=BOn;

            SetFocus;
          end; {If not found..}
        end;

      end; {with..}
    end;
  {$ENDIF}
end;



procedure TTxLine.Id3LocFEnter(Sender: TObject);
begin
  {$IFDEF SOP}
    //PR: 24/01/2017 ABSEXCH-19451 Check read-only status
    If not (Id3LocF.ReadOnly) and (UseEMLocStk) and (EmptyKey(Id3LocF.Text,MLocKeyLen)) then
    Begin
      {Id3LocF.Text:=ExLocal.LCust.DefMLocStk; v4.32 method

      If (EmptyKey(Id3LocF.Text,MLocKeyLen)) then
        Id3LocF.Text:=ExLocal.LStock.DefMLoc;}

      Id3LocF.Text:=GetProfileMLoc(ExLocal.LCust.DefMLocStk,ExLocal.LStock.DefMLoc,'',0);

      {$IFDEF CU} {* Call hooks here *}

        If (Sender is Text8pt) and (ExLocal.InAddEdit) and (Not EmptyKey(Id3SCodeF.Text,StkKeyLen)) then
        With (Sender as Text8pt) do
        Begin
          Text:=TextExitHook(4000,59,Text,ExLocal);

        end; {With..}
      {$ENDIF}
    end;

    If (UseEMLocStk) and (Syss.UseMLoc) then
      NegQtyChk:=BOff;
  {$ENDIF}
end;


procedure TTxLine.Id3LocFExit(Sender: TObject);

Var
  SCode      :  Str20;
  FoundCode  :  Str10;

  FoundOk,
  AltMod2     :  Boolean;


begin

  {$IFDEF SOP}

    Begin
      Form2Id;

      If (Sender is Text8pt) then
      With (Sender as Text8pt) do
      Begin
        AltMod2:=Modified;

        FoundCode:=Strip('B',[#32],Text);

        Scode:=ExLocal.LId.StockCode;

        If (((AltMod or AltMod2 or HadDefLoc) or ((FoundCode='') and Syss.UseMLoc)) and (ActiveControl<>CanCP1Btn)
            and  (((Syss.UseMLoc) and (Is_FullStkCode(SCode))) or (Syss.UseLocDel))) then
        Begin
          HadDefLoc:=BOff;
          
          StillEdit:=BOn;

          FoundOk:=(GetMLoc(Self.Owner,FoundCode,FoundCode,SCode,77*Ord(Syss.UseMLoc)));

          If (FoundOk) then {* Credit Check *}
          With ExLocal do
          Begin

            AssignFromGlobal(MLocF);


          end;


          If (FoundOk) then
          Begin

            StopPageChange:=BOff;

            StillEdit:=BOff;

            Text:=FoundCode;



            With ExLocal,LId do
            Begin
              MLocStk:=FoundCode;

              SendToObjectStkEnq(StockCode,MLocStk,LInv.CustCode,LInv.Currency,-1,0);

              If (Syss.UseMLoc) then
              Begin
                SetLink_Stock(LId,LInv,LCust,1,0,Qty*QtyMul,1);

                If (LId.VATCode=VATMCode) then {Reset Inclusive rate as price will be overwritten by location re-calculation}
                  LId.VATCode:=VATICode;

                CalcVATExLocal(ExLocal,BOff,nil);

                LastQtyValue:=0.0; {Force a re check as it is a new location}
                FirstQty:=BOn;
                NegQtyChk:=BOff;
              end;
            end;

            OutId;

            // CJS 2016-01-15 - ABSEXCH-17102 - 4.5 - Intrastat on Transaction Line
            // Doesn't appear to be necessary (fix for old bug?) and interferes
            // with changing to the Intrastat tab, so removed the code.
            {
            If (Id3QtyF.CanFocus) then
              Id3QtyF.SetFocus;
            }
          end
          else
          Begin
            StopPageChange:=BOn;

            SetFocus;
          end; {If not found..}
        end;

      end; {with..}
    end; {If..}
  {$ENDIF}
end;


procedure TTxLine.ID4QPTFEnter(Sender: TObject);
begin

  With ExLocal do
    If (LastEdit) then
      LastQtyValue:=LastId.QtyPick
  else
    LastQtyValue:=0;

  GenSelect:=Not InPassing;

end;

procedure TTxLine.ID4QPTFExit(Sender: TObject);
Var
  Flg,
  FLowStk     :  Boolean;
  FoundCode   :  Str20;

begin

  Begin
    Form2Id;

    FLowStk:=Boff;

    If (ActiveControl<>CanCP1Btn) and (GenSelect) then
    With ExLocal,LId do
    Begin
      {$IFDEF CU} {* Call hooks here *}
        QtyPick:=ValueExitHook(4000,56,QtyPick,ExLocal,DoFocusFix);

        Id4QPTF.Value:=Ea2Case(LId,LStock,QtyPick);;

      {$ENDIF}

     //PR: 02/08/2012 ABSEXCH-12746 Add AllowPicking check
     If AllowPicking and ((LastQtyValue<>QtyPick) or (BadQty)) and (Not EmptyKey(StockCode,StkKeyLen)) then
     Begin

       {$IFDEF STK}
         If (LStock.StockCode<>StockCode) then
         Begin
           GetStock(Self,StockCode,Foundcode,-1);

           AssignFromGlobal(StockF);
         end
         else
           AssignToGlobal(StockF);



         If (LInv.InvDocHed In StkAllSet) and (Syss.UseStock) and (QtyPick<>0) then
         Begin
           Check_StockCtrl(StockCode,(QtyPick-LastQtyValue)*QtyMul,2,FLowStk,SIN,LId,Self.Handle);

           fBadPickQty:=FLowStk;

           {Re Apply cost price here for non FIFO & Serial nos}
           If (IdDocHed In SalesSplit) and (QtyPick<>0) and (Not (FIFO_Mode(LStock.StkValType) In [2,3,5]))
           and (LStock.StockType<>StkDescCode) then
           Begin
             CostPrice:=FIFO_GetCost(LStock,LInv.Currency,Qty*QtyMul,QtyMul,MLocStk);

             Id3CostF.Value:=DisplayPackCost;
           end;

           If (Not FLowStk) then
           Begin

             InPassing:=BOn;

             {FieldNextFix(Self.Handle,ActiveControl,Sender);}

             InPassing:=BOff;
           end;
         end;


         {$IFDEF CU} {* Call hooks here *}
                     {* Auto set Qty Written off based on Qty Picked *}

           //PR: 19/07/2010 Fix for ABSEXCH-10016. If we're setting focus back to the Picked Qty field because
           //of negative stock, then don't call hook 13 (Exit Picked Qty.)
           If (Not Id4QWTF.ReadOnly) and (Sender=Id4QPTF) and not FLowStk then
           Begin
             LId.QtyPick:=Id4QPTF.Value;
             Id4QWTF.Value:=ValueExitHook(4000,13,Id4QWTF.Value,ExLocal,DoFocusFix);
           end;

         {$ENDIF}


       {$ENDIF}

       If (Sender is TCurrencyEdit) then
         With TCurrencyEdit(Sender) do
           If (FLowStk) and (CanFocus) then {* Force adjustment *}
             SetFocus;
     end;

    end; {With..}
  end; {If..}
end;



procedure TTxLine.Id5JCodeFExit(Sender: TObject);

Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;
  // CJS 2013-09-13 - ABSEXCH-13192 - add Job Costing to user profile rules
  JobCCDept: CCDepType;
begin
  {$IFDEF PF_On}
    FFocusedControl := nil;

    If (Sender is Text8pt) then
    With (Sender as Text8pt) do
    Begin
      AltMod:=Modified;

      FoundCode:=Strip('B',[#32],Text);

      If (AltMod)  and (ActiveControl<>CanCP1Btn) and (GenSelect) and (JBCostOn) then
      Begin
        If (FoundCode<>'') then
        Begin

          StillEdit:=BOn;

          FoundOk:=(GetJob(Self.Owner,FoundCode,FoundCode,4));

          If (FoundOk) then {* Credit Check *}
          With ExLocal do
          Begin
            StopPageChange:=BOff;

            AssignFromGlobal(JobF);

            Text:=FoundCode;

            InPassing:=BOn;

            {FieldNextFix(Self.Handle,ActiveControl,Sender);}

            InPassing:=BOff;

            If (DocHed In PurchSplit-[PPY]) and (JBCostOn) and (Not StopPageChange) then {* Set Nominal Code *}
            With ExLocal,LId do
            Begin
              Form2Id;
              NomCode:=Job_WIPNom(NomCode,JobCode,AnalCode,StockCode,MLocStk,CustCode);
              OutId;
            end;

            // CJS 2013-09-13 - ABSEXCH-13192 - add Job Costing to user profile rules
            if (JBCostOn) then
            begin
              JobUtils.GetJobCCDept(FoundCode, JobCCDept);
              With LCust do
                LId.CCDep := GetProfileCCDepEx(CustCC, CustDep, LId.CCDep, LStock.CCDep, JobCCDept, 0);
                //HV and R Jha 06/01/2016, JIRA-14878, CC/Dept Rules set in Password Settings not respected when Job Code added to transction line items on SOR.
              Id3CCF.Text := LId.CCDep[True];
              Id3DepF.Text := LId.CCDep[False];
            end;

          end
          else
          Begin
            StopPageChange:=BOn;

            SetFocus;
          end; {If not found..}
        end
        else
        Begin
          If (JBCostOn) then
          With ExLocal do
          Begin
            {$IFDEF STK}
              Form2Id;
              SetLink_Stock(LId,LInv,LCust,1,0,LId.Qty*LId.QtyMul,254);
              OutId;
            {$ENDIF}
          end;

          Id5JAnalF.Text:='';

        end;

        
      end;

    end;
  {$ENDIF}
end;


procedure TTxLine.Id5JAnalFExit(Sender: TObject);
Var
  FoundCode  :  Str20;

  FoundOk,
  AltMod     :  Boolean;


begin
  {$IFDEF PF_On}
    FFocusedControl := nil;
    If (Sender is Text8pt) then
    With (Sender as Text8pt) do
    Begin
      AltMod:=Modified;

      FoundCode:=Strip('B',[#32],Text);

      If (((AltMod) or (FoundCode='')) and (Not EmptyKey(Id5JCodeF.Text,JobCodeLen))) and (ActiveControl<>CanCP1Btn) and (GenSelect) and (JBCostOn) then
      Begin

        StillEdit:=BOn;

        FoundOk:=(GetJobMisc(Self.Owner,FoundCode,FoundCode,2,Anal_FiltMode(DocHed)));

        If (FoundOk) then {* Credit Check *}
        With ExLocal do
        Begin

          StopPageChange:=BOff;

          AssignFromGlobal(JMiscF);

          Text:=FoundCode;

          InPassing:=BOn;

          {FieldNextFix(Self.Handle,ActiveControl,Sender);}

          InPassing:=BOff;

          If (DocHed In PurchSplit-[PPY]) and (JBCostOn) and (Not StopPageChange) then {* Set Nominal Code *}
          With ExLocal,LId do
          Begin
            Form2Id;
            NomCode:=Job_WIPNom(NomCode,JobCode,AnalCode,StockCode,MLocStk,CustCode);
            OutId;
          end;
          
        end
        else
        Begin
          StopPageChange:=BOn;

          SetFocus;
        end; {If not found..}
      end;

    end;
  {$ENDIF}

end;


procedure TTxLine.Id3VATFEnter(Sender: TObject);
begin
  GenSelect:=Not InPassing;
  FFocusedControl := Sender as TWinControl;
end;


procedure TTxLine.ProcessVATCode(Sender: TObject; Const CalledOnExit : Boolean);
Var
  Flg         :  Boolean;

  FoundCode   :  Str20;

  BalNow      :  Double;

  AltMod      :  Boolean;

  mbRet: Word;
begin
  Begin


    Form2Id;

    If (Sender is TSBSComboBox) then
    With (Sender as TSBSComboBox) do
    Begin
      AltMod:=Modified;

      If (ActiveControl<>CanCP1Btn) and (GenSelect or AltMod) then
      With ExLocal,LInv,LId do
      Begin

        {$IFDEF CU} {* Call any pre store hooks here *}
          If (Not ReadOnly) And CalledOnExit then
            GenHooks(4000,6,ExLocal,DoFocusFix);
        {$ENDIF}

        BalNow:=NetValue;


       If (BalNow<>0) and (Qty<>0) then
       Begin

         If (LCust.CustCode<>LInv.CustCode) then
         Begin
            GetCust(Self,LInv.CustCode,FoundCode,IsACust(CustSupp),-1);


           AssignFromGlobal(CustF);
         end
         else
           AssignToGlobal(CustF);

         //PR: 22/12/2009 At request of MR, extended check to include VatCode 3 as well as A.

         // CJS 2014-09-08 - ABSEXCH-15513 - allow VAT Rate A on Services for Ireland
         If not ValidECServiceVATCode(ExLocal) Then
         Begin
           // CJS 2014-03-04 - ABSEXCH-15098 - wording on VAT code for EC Services
           // CJS 2014-10-22 - ABSEXCH-15743 - Extend EC Service VAT Code validation to Sales, for Ireland only
           MessageDlg (Format('%s Code ''%s'' cannot be used for Services on ' +
                              IfThen(InvDocHed in PurchSplit, 'Purchase', 'Sales') + ' Transactions.'#10 +
                              'Please change to the VAT Code applicable for this service.', [CCVATName^, VatCode]), mtError, [mbOK], 0);
           StopPageChange:=BOn;
           SetFocus;
         End // PurchSplit
         Else
         Begin
           Flg :=(((Not (VATCode In VATEECSet)) or (LCust.EECMember)));

           If (Not Flg) then
           Begin

             Warn_BADVATCode(VATCode);

             StopPageChange:=BOn;
             SetFocus;

           end
           else
           Begin
             {$IFDEF VAT}
               If ((VATCode = VATICode) or (VATCode = VATMCode)) and (ActiveControl = ID3VatF) then   // SSK 29/05/2017 2017-R1 ABSEXCH-13530: changes for Inclusive VAT ('I')
               begin
                 if not FUnitPriceChanged then
                   mbRet := MessageDlg('Please ensure the U/Price is correct before applying' + #13 +
                          'an update to the Inclusive VAT(I) code', mtWarning, [mbOk, mbCancel], 0)
                 else
                   mbRet := mrOK;

                 if (mbRet = mrOk) then
                 begin
                   With TSBSComboBox(Sender) do
                       GetIRate(Parent.ClientToScreen(ClientPos(Left,Top+23)),Color,Font,Self.Parent,LViewOnly,VATIncFlg);
                     VATCode := VATICode;
                 end
                 else
                 begin
                   setfocus;
                   VATCode := Id3VATF.Items[0][1];
                 end;
               end;
             {$ENDIF}

             CalcVATExLocal(ExLocal,BOff,nil);

             OutId;

             StopPageChange:=BOff;
           end;
         End; // Else
       end;

      end; {With..}
    end; {With..}
  end; {If..}
  EnableECServiceCheckBox;
end;

procedure TTxLine.Id3VATFExit(Sender: TObject);
Begin // Id3VATFExit
  FFocusedControl := nil;
  ProcessVATCode(Sender, True);
End; // Id3VATFExit

procedure TTxLine.Id3VATFClick(Sender: TObject);
Begin // Id3VATFClick
  ProcessVATCode(Sender, False);
End; // Id3VATFClick


procedure TTxLine.Id3SBoxExit(Sender: TObject);
begin
  If (Sender is TScrollBox) then
    TScrollBox(Sender).VertScrollBar.Position:=0;
end;




procedure TTxLine.Id1Desc1FKeyPress(Sender: TObject; var Key: Char);
begin
  If (Sender is Text8pt) then
    With Text8pt(Sender) do
    Begin
      If (SelStart>=MaxLength) then {* Auto wrap around *}
        SetNextLine(Self,Sender,Id1Desc6F,Parent,Key);
    end;

end;

procedure TTxLine.Id3Desc1FKeyPress(Sender: TObject; var Key: Char);
begin
  If (Sender is Text8pt) then
  With Text8pt(Sender) do
  Begin
    If (SelStart>=MaxLength) then {* Auto wrap around *}
      SetNextLine(Self,Sender,Id3Desc6F,Parent,Key);
  end;

end;


procedure TTxLine.LUD1FEntHookEvent(Sender: TObject);
Var
  CUUDEvent  :  Byte;
  Result     :  LongInt;

begin
  CUUDEvent := 0;
  {$IFDEF CU}
    If (Sender is Text8Pt)then
      With (Sender as Text8pt) do
      Begin
        If (Not ReadOnly) then
        Begin
        If (Sender=LUD1F) then
        Begin
          ExLocal.LId.LineUser1:=Text;
          CUUDEvent:=1;
        end
        else
        If (Sender=LUD2F) then
        Begin
          ExLocal.LId.LineUser2:=Text;
          CUUDEvent:=2;
        end
        else
        If (Sender=LUD3F) then
        Begin
          ExLocal.LId.LineUser3:=Text;
          CUUDEvent:=3;
        end
        else
        If (Sender=LUD4F) then
        Begin
          ExLocal.LId.LineUser4:=Text;
          CUUDEvent:=4;
        end
        else //PR: 12/10/2011 Add new UDFs - Hook points are 211-216, need to subtract 30 which is added below, so 181-186
        if Sender = edtUdf5 then
        begin
          ExLocal.LId.LineUser5:=Text;
          CUUDEvent:=181;
        end
        else
        if Sender = edtUdf6 then
        begin
          ExLocal.LId.LineUser6:=Text;
          CUUDEvent:=182;
        end
        else
        if Sender = edtUdf7 then
        begin
          ExLocal.LId.LineUser7:=Text;
          CUUDEvent:=183;
        end
        else
        if Sender = edtUdf8 then
        begin
          ExLocal.LId.LineUser8:=Text;
          CUUDEvent:=184;
        end
        else
        if Sender = edtUdf9 then
        begin
          ExLocal.LId.LineUser9:=Text;
          CUUDEvent:=185;
        end
        else
        if Sender = edtUdf10 then
        begin
          ExLocal.LId.LineUser10:=Text;
          CUUDEvent:=186;
        end;

          Result:=IntExitHook(4000,30+CUUDEvent,-1,ExLocal);

          If (Result=0) then
            SetFocus
          else
          With ExLocal do
          If (Result=1) then
          Begin
            Case CUUDEvent of
              1  :  Text:=LId.LineUser1;
              2  :  Text:=LId.LineUser2;
              3  :  Text:=LId.LineUser3;
              4  :  Text:=LId.LineUser4;

            //PR: 11/10/2011 v6.9 new user fields
            181  :  Text:=LId.LineUser5;
            182  :  Text:=LId.LineUser6;
            183  :  Text:=LId.LineUser7;
            184  :  Text:=LId.LineUser8;
            185  :  Text:=LId.LineUser9;
            186  :  Text:=LId.LineUser10;

            end; {Case..}
          end;
        end;
     end; {With..}

  {$ELSE}
    CUUDEvent:=0;

  {$ENDIF}
end;

procedure TTxLine.LUD1FExit(Sender: TObject);
begin
  If (Sender is Text8Pt)  and (ActiveControl<>CanCP1Btn) then
    Text8pt(Sender).ExecuteHookMsg;
end;


// CJS 2014-09-08 - ABSEXCH-15513 - allow VAT Rate A on Services for Ireland
function ValidECServiceVATCode(ExLocal: TdExLocal): Boolean;
begin
  Result := True;
  // CJS 2014-10-22 - ABSEXCH-15743 - Extend EC Service VAT Code validation to Sales, for Ireland only
  // For Ireland
  if (CurrentCountry = IECCode) and (ExLocal.LId.ECService) then
  begin
    // Allow VAT Code 'A' for Purchases and VAT Code 'D' for Sales. Disallow
    // any other VAT Code
    Result := ((ExLocal.LInv.InvDocHed in PurchSplit) and (ExLocal.LId.VATCode = 'A')) or
              ((ExLocal.LInv.InvDocHed in SalesSplit) and (ExLocal.LId.VATCode = 'D'));
  end
  else
  // For UK
  begin
    // Disallow codes 'A' and '3' on Purchase Transaction Lines where the EC
    // Service flag is set.
    if (ExLocal.LInv.InvDocHed in PurchSplit) and ExLocal.LId.ECService then
      Result := not (ExLocal.LId.VATCode in [VATEECCode, '3']);
  end;
end;


// MH 06/11/2014 ABSEXCH-15798: Added Execution Mode so I can add validation in for the Edit of SDN lines
Function CheckCompleted(      Edit,MainChk, BadQty, NegQtyChk : Boolean;
                              ExLocal   : TdExLocal;
                              ParentF   : TForm;
                              CUPtr     : Pointer;
                        Var   ShowMsg   : Boolean;
                        Var   MainStr   : Str255;
                        Const ExecMode  : enumCheckCompletedMode)  : Boolean;

Const
  NofMsgs      =  27;

Type
  PossMsgType  = Array[1..NofMsgs] of String[91];

Var
  PossMsg  :  ^PossMsgType;

  ExtraMsg :  Str80;

  Test     :  Byte;

  FoundCode:  Str20;

  Loop,
  OrigShowMsg,
  FLowStk
           :  Boolean;

  mbRet    :  Word;

  FoundLong
           :  LongInt;
  SerDT    :  DocTypes;
  SnoAvail,
  SnoNeed,
  SnoPick,
  BalNow   :  Double;

  {$IFDEF CU}
    LineCU  :  TCustomEvent;
  {$ENDIF}

  // PKR. 28/01/2016. ABSEXCH-17210. Commodity Code validation
  iCode    : integer;
  // MH 31/05/2016 2016-R2 ABSEXCH-17488: Changed to Int64 to avoid overflows with 10 digit TARIC codes > MaxLongInt
  iValue   : Int64;
  // MH 31/05/2016 2016-R2 ABSEXCH-17488: Added support for 10 character TARIC Codes
  iLen : Integer;

  // Reference to field to set focus to in the event of a validation error
  //ErrorControl : TWinControl;
Begin
  {***************************************************************************}
  {* This section has been replicated in TInvLine.CheckValid in oIDetail.Pas *}
  {***************************************************************************}

  New(PossMsg);


  FillChar(PossMsg^,Sizeof(PossMsg^),0);

  PossMsg^[1]:='General Ledger Code is not valid.';
  PossMsg^[2]:=CCVATName^+' Code is not valid.';
  PossMsg^[3]:=' Cost Centre/ Department Code not valid.';
  PossMsg^[4]:='Job Code is not valid.';
  PossMsg^[5]:='Job Analysis Code is not valid.';
  PossMsg^[6]:='Line Over Delivered'; {* Over delivered *}
  PossMsg^[7]:='Maximum line value exceeded.';
  PossMsg^[8]:='Stock Code not valid.';
  PossMsg^[9]:='The Quantity required is not valid. Negative Stock is not allowed';
  PossMsg^[10]:='The Location Code is not valid.';
  PossMsg^[11]:='The EC '+CCVATName^+' Code is not valid for this type of account.';
  PossMsg^[12]:='That G/L and currency combination are not allowed.';
  PossMsg^[13]:='The Commitment has been exceeded';
  PossMsg^[14]:='Cannot pick that many serial no under pro mode';
  PossMsg^[15]:='The checkstock routine was never called, so call it now';
  PossMsg^[16]:='A valid Job code must be present for that G/L Code.';
  PossMsg^[17]:='Location changed on Bin stock code and loc filter applied.';
  PossMsg^[18]:='An additional check is made via an external hook';
//PR: 27/01/2009 Added check for negative quote  (2004315100750)
  PossMsg^[19]:='Invalid quantity. Quotes can not be negative.';
  //PR: 27/04/2009 Check for Multi-Buy Discounts error
  PossMsg^[20]:='The quantity required for the specified Multi-Buy(s) exceeds the line quantity.';
  //PR: 01/09/2009 Check for EC Service Dates
  PossMsg^[21]:='EC Service Dates must be set.';
  PossMsg^[22]:='The EC Service End Date must not be earlier than the Start Date.';
  // MH 06/11/2014 ABSEXCH-15798: Prevent user increasing the SDN qty on lines
  PossMsg^[23]:='The Quantity on an Order Payments Delivery Note cannot be increased or reduced below zero';
  // MH 02/06/2015 2015-R1 ABSEXCH-16475: Allow limited edit of paid Orders
  PossMsg^[24]:='The Quantity on an Order Payments Order Line cannot be reduced';
  // CJS 2016-01-14 - ABSEXCH-17102 - 4.5 - Intrastat on Transaction Line
  PossMsg^[25] := 'A Country Code must be selected for Intrastat';
  PossMsg^[26] := 'A Nature of Transaction Code (NoTc) must be selected for Intrastat';
  // PKR. 28/01/2016. ABSEXCH-17210. Validation of Commodity Code
  PossMsg^[27] := 'The Commodity/TARIC Code must be 8 or 10 numeric characters or blank.';


  {$IFDEF CU}
     If (Assigned(CUPtr)) then
       LineCU:=CUPtr
     else
       LineCU:=Nil;
  {$ENDIF}

  FLowStk:=BOff;

  Loop:=BOff;

  Test:=1;

  Result:=BOn;  OrigShowMsg:=ShowMsg;

  SnoAvail:=0.0; SnoPick:=0.0; SNoNeed:=0.0;

  BalNow:=InvLTotal(ExLocal.LId,Not Syss.SepDiscounts,0);

  MainStr:='';

  // Reference to field to set focus to in the event of a validation error
  //ErrorControl := NIL;

  While (Test<=NofMsgs) and (Result) do
  With ExLocal,LId do
  Begin
    ExtraMsg:='';

    ShowMsg:=BOn;

    Case Test of

      1  :  Begin
              Result:=(BalNow=0);

              If (Not Result) then
              Begin
                Result:=GetNom(ParentF,Form_Int(NomCode,0),FoundLong,-1);

                If (Result) and (Not SBSIn) then
                  Result:=(Nom.NomType In BankSet+ProfitBFSet);
              end;

            end;

      2  :  Begin
              Result:=((VATCode In VATSet) or (BalNow=0));

              //PR: 22/12/2009 At request of MR, extended check to include VatCode 3 as well as A.
              // CJS 2014-09-08 - ABSEXCH-15513 - allow VAT Rate A on Services for Ireland
              If not ValidECServiceVATCode(ExLocal) Then
               Begin
                 Result := False;
                // CJS 2014-10-22 - ABSEXCH-15743 - Extend EC Service VAT Code validation to Sales, for Ireland only
                PossMsg^[2]:='This ' + CCVATName^ + ' Code cannot be used for Services on ' +
                             IfThen(Inv.InvDocHed in PurchSplit, 'Purchase', 'Sales') + ' Transactions';
               End; // If (IdDocHed In PurchSplit) And ECService And (VATCode In VATEECSet)
            End;

      {$IFDEF PF_On}

        3  :  Begin
                Result:=((Not Syss.UseCCDep) or (Not LComplete_CCDep(LId,BalNow)));

                If (Not Result) then
                Begin
                  Result:=BOn;
                  For Loop:=BOff to BOn do
                  Begin

                    Result:=(GetCCDep(ParentF,CCDep[Loop],FoundCode,Loop,-1) and (Result));

                  end;
                end;

              end;

        4  :  Begin

                Result:=((Not JBCostOn) or (Not LComplete_JobAnl(LId,BalNow)) or (EmptyKey(JobCode,JobCodeLen)));

                If (Not Result) then
                  Result:=GetJob(ParentF,JobCode,FoundCode,-1);

              end;

        5  :  Begin
                Result:=((Not JBCostOn) or (Not LComplete_JobAnl(LId,BalNow)) or (EmptyKey(JobCode,JobCodeLen)));

                If (Not Result) then
                  Result:=GetJobMisc(ParentF,AnalCode,FoundCode,2,-1);
              end;

        18  :  Begin {* Opportunity for hook to validate this line as well. If From loop, use cahced event controller *}
                 {$IFDEF CU}
                   If (Assigned(LineCU)) then
                   With LineCU do
                   Begin
                     If (GotEvent) then
                     Begin
                       {v5.50. Alter current line to reflect this one. Returns false if could not be assigned}

                       If TInvoice(EntSysObj.Transaction).ChangeCurrentLine(Exlocal.LId) then
                       Begin
                         Execute;
                         Result:=EntSysObj.BoResult;
                       end
                       else
                         Result:=BOff;

                     end;
                   end
                   else
                     Result:=ValidExitHook(4000,18,ExLocal);

                   ShowMsg:=BOff;

                 {$ENDIF}
              end;

      {$ENDIF}

      {$IFDEF STK}

        6  :  Begin
                Result:=(Not (IdDocHed In OrderSet)) or ((KitLink<>0) and (Not Is_FullStkCode(StockCode)));

                If (Not Result) then
                  Result:=(Not Warn_OverDelv(LId,0,BOn,Not MainChk));

                If (Not MainChk) then
                  PossMsg^[Test]:='';

                ShowMsg:=Result;
              end;

       15  :  Begin
                Result:=(Not (LInv.InvDocHed In StkDedSet+StkAllSet)) or (Not Syss.UseStock) or (not CheckNegStk) or (NegQtyChk);

                If (Not Result) then
                Begin
                  If (LastId.MLocStk<>MLocStk) then {* Discount last qty as loc has changed and this is not an edit now *}
                    LastId.Qty:=0;

                  Check_StockCtrl(StockCode,(Qty*QtyMul)-(LastId.Qty*LastId.QtyMul),1+Ord(CheckNegStk and (Not (IdDocHed In OrderSet))),
                           FLowStk,IdDocHed,LId,ParentF.Handle);

                  Result:=Not FLowStk;

                  ShowMsg:=Result;

                  {$IFDEF SOP}
                   {$B-}
                    If Assigned(ParentF) and (ParentF is TTXLine) then

                   {$B+}
                    try
                      With TTXLine(ParentF), ExLocal do
                      Begin
                        If (Syss.UseMLoc) and (Assigned(TxAutoMLId)) then  {* Adjust quantity based on split *}
                        Begin
                          TxAutoMLId^.SetIdQty(LId);
                          OutId;
                        end;
                      end;
                    except;

                    end;
                  {$ENDIF}

                end;
              end;
         17  :  Begin
                  {$IFDEF SOP}                               {* v5.70. Don't think this is a problem with snos now as we auto resynch loc for them. Still an issue with bins *}
//                    If (Syss.FiltSNoBinLoc) and ((BinQty<>0.0) {or (SerialQty<>0.0)}) and (Syss.UseMLoc) and (Not MainChk) and (MLocStk<>LastId.MLocStk) then
                    If FilterSerialBinByLocation(Syss.FiltSNoBinLoc, LInv.InvDocHed in SalesSplit // NF:
                    , ChemilinesStockLocHookEnabled) and (BinQty<>0.0) and (Syss.UseMLoc)
                    and (Not MainChk) and (MLocStk<>LastId.MLocStk) then
                    Begin
                      ShowMsg:=BOff;

                      Set_BackThreadMVisible(BOn);

                      Result:=(CustomDlg(Application.MainForm,'WARNING!','Location Change',
                                 'The Location code for this line has changed which will prevent you returning stock to its correct location.'+#13+#13+
                                 'It is better to zero the quantity with the original location code before changing it to a new code.'+#13+
                                 'Do you wish to continue with the new Location code?',
                                 mtConfirmation,
                                 [mbYes,mbNo])=mrOk);

                      Set_BackThreadMVisible(BOff);

                    end;

                  {$ENDIF}
                end;

      {$ENDIF}

      7  :  Begin

              Result:=(BalNow<=MaxLineValue32);

            end;

      8  :  Begin
              {$IFDEF STK}
                Result:=EmptyKey(StockCode,StkKeyLen);

                If (Not Result) then
                  Result:=GetStock(ParentF,StockCode,Foundcode,-1);

              {$ELSE}

                Result:=BOn;

              {$ENDIF}
            end;

      9  :  Begin
              {$IFDEF STK}
                Result:=Not BadQty;
              {$ELSE}

                Result:=BOn;

              {$ENDIF}
            end;

      10  : {$IFDEF SOP}

              If (Syss.UseMLoc) and (LComplete_MLoc(LId)) then {* Check location valid *}
              Begin
                Result:=Global_GetMainRec(MLocF,Quick_MLKey(MLocStk));
              end
              else
            {$ENDIF}
                Result:=BOn;


      11 :   With ExLocal do
               Result:=((LInv.InvDocHed In SalesSplit) and (VATCode = VATECDCode)) or
                     ((Not (LInv.InvdocHed In SalesSplit)) and (VATCode = VATEECCode)) or
                     (Not (VATCode In VATEECSet));

      12 :  Result:=Check_GLCurr(LInv,LId,0);

      16 :  Result:=Check_GLJC(LInv,LId,0);

      {$IFDEF SOP}

        13 :  If (CommitAct) and (Not MainChk) and (IdDocHed In OrderSet) then
              Begin                                       {*EX431*} {Check password stops}
                Result:=Not Check_OverCommited(LId,LastId,BOn) or (PChkAllowed_In(268) and (IdDocHed=SOR)) or (PChkAllowed_In(269) and (IdDocHed=POR));

                ShowMsg:=BOff;
              end;

      {$ENDIF}


        14 :  If (Not MainChk) and (Not ChkAllowed_In(244)) and (Is_FullStkCode(StockCode)) then
              Begin {* If picking snos then check we have enough available. If pw not to allow exit if insufficnet, set, then fail line}
              {$IFDEF SOP}
                {$IFDEF WOP}
                  SerDT:=IdDocHed;

                  If (IdDocHed In OrderSet) then
                  Begin
                    SnoPick:=QtyPick*QtyMul;

                    If (SerDT In [SOR,SQU]) then
                      SerDT:=SDN
                    else
                      SerDT:=PDN;

                  end
                  else
                    SnoPick:=Qty*QtyMul;

                  SNoNeed:=Round_Up((SNoPick-SerialQty)*StkAdjCnst[SerDT],Syss.NoQtyDec);

                  If (Stock.StockCode<>StockCode) then
                    Global_GetMainRec(StockF,StockCode);

                  If (SnoPick>SerialQty) and (SNoNeed<0) and Is_SerNo(Stock.StkValType)  then {Check there is enough serial qty}
                  Begin
                    SNoAvail:=Sno4Sale(Stock.StockFolio,SnoPick-SerialQty,0);

                    //PR: 29/08/2012 ABSEXCH-10756 Added rounding on SNoAvail as rounding on only half the check was causing rounding errors
                    If (Round_Up(SNoAvail,Syss.NoQtyDec)<Round_Up((SnoPick-SerialQty),Syss.NoQtyDec)) then
                    Begin
                      ShowMsg:=BOff;

                      ShowMessage('There are only '+Form_Real(SNoAvail,0,Syss.NoQtyDec)+' serial items available for allocation.');

                      Result:=BOff;
                    end;

                  end;
                {$ENDIF}
              {$ENDIF}
              end;

         (*** MH 02/09/2009: Reversed out change as Training felt this would cause lots of customers problems
         //PR: 27/01/2009 Added check for negative quote  (2004315100750)
         19  : Result := not NegativeQuote(ExLocal);
         ***)
         19  : Result := True;


         20  :  {$IFDEF SOP}
                //PR: 09/06/2009 - Added Abs(LID.Qty) as it wasn't dealing with -ve quantities.
                if not MainChk and (Trim(LId.StockCode) <> '') and Assigned(MBDFramesController) then
                  Result := (Abs(Ea2Case(LId, Stock, LId.Qty)) >= MBDFramesController.TotalBuyQty)
                else
                {$ENDIF}
                  Result := True;

         21 :   if LId.ECService and (LInv.InvDocHed in (SalesSplit)) then
                begin
                  Result := ValidDate(LId.ServiceStartDate) and
                            ValidDate(LId.ServiceEndDate);
                end
                else
                  Result := True;

         22 :   if LId.ECService then
                begin
                  if ValidDate(LId.ServiceStartDate) and
                     ValidDate(LId.ServiceEndDate) then
                     Result := (LId.ServiceStartDate <= LId.ServiceEndDate);
                end
                else
                  Result := True;

         23 : Begin
                {$IFDEF SOP}
                  // MH 06/11/2014 ABSEXCH-15798: Prevent user increasing the SDN qty on lines derived
                  // from the SOR, they can reduce it though to 'undeliver' stuff
                  If (ExecMode=ccStoreLine) And (LInv.thOrderPaymentElement = opeDeliveryNote) And (LID.SOPLineNo <> 0) Then
                    Result := (LId.Qty >= 0) And (LId.Qty <= LastId.Qty)
                  Else
                {$ELSE}
                    // Anything goes (literally) for legacy code SDN's
                    Result := True;
                {$ENDIF SOP}
              End; // 23 - OrdPay Qty on SDN

         24 : Begin
                {$IFDEF SOP}
                  // MH 02/06/2015 2015-R1 ABSEXCH-16475: Allow limited edit of paid Orders, if there is a payment
                  // for the line then they can only increase the quantity, if no payments then no limitations
                  If (ExecMode=ccStoreLine) And (LInv.thOrderPaymentElement = opeOrder) And
                     OrderPaymentsCustomisationTransactionTracker(ExLocal.LInv).cttLineHasPayments[ExLocal.LId.ABSLineNo] Then
                  Begin
                    // Cannot reduce the line qty, but can increase it
                    Result := (LId.Qty >= LastId.Qty);

// MH 02/06/2015 Exch-R1: Removed as it doesn't work as EL moves the focus to the Stock Code
// causing any OnExit validation to kick off as well, resulting in two error messages
//                    If (Not Result) And Assigned(ParentF) And (ParentF Is TTxLine) Then
//                      // Reference to field to set focus to in the event of a validation error
//                      ErrorControl := TTxLine(ParentF).Id3QtyF;
                  End // If (ExecMode=ccStoreLine) And (LInv.thOrderPaymentElement = opeOrder) And OrderPaymentsCustomisationTransactionTracker(ExLocal.LInv).cttLineHasPayments[ExLocal.LId.ABSLineNo]
                  Else
                {$ELSE}
                    // Anything goes
                    Result := True;
                {$ENDIF SOP}
              End; // 24 - OrdPay Qty on SOR
          25: Begin
                If LId.SSDUseLine then
                  Result := (Trim(LId.SSDCountry) <> '')
                else
                  Result := True;
              End;
          26: Begin
                If LId.SSDUseLine then
                  Result := (Trim(LId.tlIntrastatNoTc) <> '')
                else
                  Result := True;
              End;
          // PKR. 28/01/2016. ABSEXCH-17210. Validation of Commodity Code
          27: begin
                // Validation rules for Commodity Code:
                // - If Intrastat is swtched on, then the Commodity Code must be blank or 8 or 10 characters.
                // - If Intrastat is switched off, then no validation.
                Result := true;
                if (Syss.Intrastat) then
                begin
                  if (LId.SSDUseLine) then // True if "Override Intrastat Settings on this line" is switched on
                  begin
                    // PKR. 05/02/2016. ABSEXCH-17261. Validation of Commodity Code fails when it contains leading/trailing spaces
                    // MH 31/05/2016 2016-R2 ABSEXCH-17488: Added support for 10 character TARIC Codes
                    iLen := Length(Trim(LId.SSDCommod));
                    Result := (iLen = 0) or (iLen = 8) or (iLen = 10);

                    // If it is 8 or 10 characters long, check it's numeric
                    if (iLen = 8) or (iLen = 10) then
                    begin
                      // if iCode > 0 then the integer conversion failed.
                      Val(LId.SSDCommod, iValue, iCode);
                      Result := (iCode = 0) and (iValue >= 0); // Check for positive integers only
                    end;
                  end;
                end;
              end;
    end;{Case..}

    If (Result) then
      Inc(Test);
  end; {While..}

  If (Not Result) and (ShowMsg) and (Not MainChk) then
    mbRet:=MessageDlg(ExtraMsg+PossMsg^[Test],mtWarning,[mbOk],0);

// MH 02/06/2015 Exch-R1: Removed as it doesn't work as EL moves the focus to the Stock Code
// causing any OnExit validation to kick off as well, resulting in two error messages
//  // Reference to field to set focus to in the event of a validation error
//  If (Not Result) And Assigned(ErrorControl) Then
//  Begin
//    If ErrorControl.CanFocus Then
//      ErrorControl.SetFocus;
//  End; // If (Not Result) And Assigned(ErrorControl)

  If (MainChk) then
  Begin
    If (Not Result) then
      MainStr:=#13+ExtraMsg+PossMsg^[Test]+#13+'Line '+InttoStr(ExLocal.LId.LineNo);

    ShowMsg:=OrigShowMsg;
  end;

  Dispose(PossMsg);

end; {Func..}



{$IFDEF SOP}
{ ==== Proc to Generate Automatic ==== }

  Procedure TTxLine.MLoc_GenLocSplit(Fnum,
                                     Keypath:  Integer);

  Var
    Found  :  Boolean;
    TmpStr :  Str20;

    DCnst  :  Integer;

    TmpId  :  Idetail;

  Begin
    If (Assigned(TxAutoMLId)) then
    With TxAutoMLId^,EXLocal,LId do
    Begin
      LGetRecAddr(Fnum);

      Found:=FindDir(BOn);

      While (Found) do
      With CarryFR^ do
      Begin
        If (idLoc<>NdxWeight) then
        Begin
          LId.MLocStk:=IdLoc;

          LId.SerialQty:=0;

          LId.BinQty:=0.0;

          If (Not (IdDocHed In StkAdjSplit)) then
          Begin
            LineNo:=LInv.ILineCount;

            {* Set on all Lines *}


            ABSLineNo:=LInv.ILineCount;

            If (Stock.StockCode<>StockCode) then
              LGetMainRecPos(StockF,StockCode);


            Qty:=1; QtyMul:=1;  QtyDel:=0.0; QtyPick:=0.0;  QtyPWOff:=0.0; QtyWOff:=0.0;

            TmpId:=LId;

            Link_StockCtrl(TmpId,LInv,LCust,1,0,0,Qty*QtyMul,1,LastIns,LineDesc);

            DCnst:=1;
          end
          else
            DCnst:=-1;

          CalcCases(Qty,QtyMul,idQTLoc*DCnst);

          Self.Enabled:=BOff;

          TForm(Self.Owner).Enabled:=BOff;

          Control_SNos(LId,LInv,LStock,1,Self);

          Self.Enabled:=BOn;

          With TForm(Self.Owner) do
          Begin
            Enabled:=BOn;
            Show;
          end;

          Deduct_AdjStk(LId,LInv,BOn);

          Inc(LInv.ILineCount);

          CalcVATExLocal(ExLocal,BOff,nil);

          Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath);

          Report_BError(Fnum,Status);

          If (StatusOk) then
          Begin

            If (Not (IdDocHed In StkAdjSplit)) then
              UpdateRecBal(LId,LInv,BOff,BOn,0);

            {$IFDEF PF_On}
              If (JbCostOn) and ((InvLLTotal(LId,BOn,0)<>0) or (InvLLTotal(LastId,BOn,0)<>0)) and (LId.KitLink=0) then
                Update_JobAct(LId,LInv);
            {$ENDIF}
          end;

        end;

        Found:=FindDir(BOff);

      end; {While..}

      LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);

      Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPath,Keypath); {* Re-Establish Position *}

      Send_UpdateList(BOff,31);
    end; {End With..}
  end;

procedure TTxLine.Update_LiveCommit(IdR     :  IDetail;
                                    DedMode :  SmallInt);

{$IFDEF POST}
  Var
    PostObj  :  ^TEntPost;

  Begin
      If (CommitAct) and (IdR.IdDocHed In CommitLSet) and (ExLocal.LInv.NomAuto) then
    Begin
      If (Assigned(CommitPtr)) then
      Begin
        PostObj:=CommitPtr;
        try
          PostObj^.Update_LiveCommit(IdR,DedMode);
        except
          Dispose(PostObj,Destroy);
          CommitPtr:=nil;
        end;
      end
      else
      Begin
        AddLiveCommit2Thread(IdR,DedMode);

      end;
    end;
  end;

{$ELSE}
  Begin


  end;
{$ENDIF}

{$ENDIF}



procedure TTxLine.StoreId(Fnum,
                          KeyPAth    :  Integer);


Var
  ShowMsg,
  COk  :  Boolean;
  TmpId
       :  Idetail;
  KeyS :  Str255;

  MbRet:  Word;

  Mode :  Byte;

  OTotQty,
  NTotQty
       :  Real;

  Dnum,
  Dnum2 :  Double;
  BalLast, BalNow : Double;

  { CJS 2013-08-06 - ABSEXCH-14210 - Access violation when storing Transaction }
  ButtonState: Boolean;
  CursorState: TCursor;

Begin
  {*********************************************************************}
  {* This section has been replicated in TInvLine.Save in oIDetail.Pas *}
  {*********************************************************************}

  KeyS:='';

  ShowMsg:=BOn;


  //PR: 02/08/2012 ABSEXCH-12746 Add AllowPicking check to stop line being stored if user has tried to pick stock for
  //a customer on hold
  if not AllowPicking then
    EXIT;

  { CJS 2013-08-06 - ABSEXCH-14210 - Access violation when storing Transaction }
  ButtonState := OkCP1Btn.Enabled;
  CursorState := Cursor;

  OkCP1Btn.Enabled := False;
  try

    Form2Id;

    Dnum2:=0.0; Dnum:=0.0;

    With ExLocal,LId do
    Begin
      {$IFDEF CU} {* Call any pre store hooks here *}

          GenHooks(4000,10,ExLocal);

      {$ENDIF}



      COk:=CheckCompleted(LastEdit,BOff,BadQty,NegQtyChk,ExLocal,Self,Nil,ShowMsg,KeyS, ccStoreLine);

      {$IFDEF BoMObj}
      If COk Then
      Begin
        If oLineBoMHelper.Active Then
        Begin
  // Should probably check the stock levels again - this appears to be a bug currently as it is
  // only checked when you exit the quantity - maybe this should be added into CheckCompleted?

          // Create exploded BoM transaction lines where appropriate
          oLineBoMHelper.CreateLines (LCust, LInv, LId);
        End // If oLineBoMHelper.Active
        Else

      End; // If COk
      {$ENDIF}


      If (COk) then
      Begin

        Cursor:=crHourGlass;

        if not ExLocal.LViewOnly then
        begin
        {$IFDEF STK}

          {$IFDEF STK} {v5.52. Open up for non SPOP versions using multi bins}

            Self.Enabled:=BOff;

            TForm(Self.Owner).Enabled:=BOff;

            if not IsAverageCostMethod or LineValuesChanged then
              Control_SNos(LId,LInv,LStock,1,Self);

            Self.Enabled:=BOn;

            With TForm(Self.Owner) do
            Begin
              Enabled:=BOn;
              Show;
            end;

          {$ENDIF}

          if not IsAverageCostMethod or LineValuesChanged then
          begin
            Deduct_AdjStk(LastId,LInv,BOff);

            Deduct_AdjStk(LId,LInv,BOn);
          end;

        {$ENDIF}
        end; // if not ExLocal.LViewOnly then
        {* Store any extra desc lines *}

        Form2Desc;

        if not ExLocal.LViewOnly then
          CalcVATExLocal(ExLocal,BOff,nil);

        {CalcVat(LId,LInv.DiscSetl);}


        If (LastEdit) then
        Begin
          If (Not TransactionViewOnly) then
          Begin

            If (LastRecAddr[Fnum]<>0) then  {* Re-establish position prior to storing *}
            Begin

              TmpId:=LId;

              LSetDataRecOfs(Fnum,LastRecAddr[Fnum]);

              Status:=GetDirect(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth,0); {* Re-Establish Position *}

              LId:=TmpId;

            end;


            {
              CJS 24/01/2011 - ASBEXCH-9963 - Silently make sure that NOMMODE
              holds the correct value. If it is 2 (StkAdjNomMode), reset it
              to 0.
            }
            if (IdDocHed <> ADJ) and (NomMode = 2) then
              NomMode := 0;

            Status:=Put_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);
          end; {Don't store if view only}
        end
        else
        Begin {* Add new record *}

          If (LastIns) then
          Begin
            TmpId:=LId;

            MoveEmUp(FullNomKey(LId.FolioRef),
                   FullIdKey(LId.FolioRef,LastAddrD),
                   FullIdKey(LId.FolioRef,LId.LineNo),
                   1,
                   Fnum,KeyPath,
                   // MH 02/11/2015 2016R1 ABSEXCH-16613: Re-instated SQL mod to improve performance when Exploding BoM's
                   mumInsert);

            LId:=TmpId;
          end;

          Inc(LInv.ILineCount);


          Status:=Add_Rec(F[Fnum],Fnum,LRecPtr[Fnum]^,KeyPAth);

        end;

        If (Not TransactionViewOnly) then
          Report_BError(Fnum,Status);

        If (StatusOk) and (Not TransactionViewOnly) then
        Begin
          LGetRecAddr(Fnum);  {* Refresh record address *}

          {* Preserv position *}

          Status:=LPresrv_BTPos(Fnum,Keypath,F[Fnum],LastRecAddr[Fnum],BOff,BOff);

          //PR: 15/11/2017 ABSEXCH-19451 Only enter this section if editing
          //a normal (non-posted transaction)
          if not LViewOnly then
          begin
            With LastId do
              UpdateRecBal(LastId,LInv,BOn,BOff,0);

            With LId do
              UpdateRecBal(LId,LInv,BOff,BOn,0);



            {$IFDEF STK}

              If (Not EmptyKey(StockCode,StkKeyLen))  then
              Begin
                With LastId do
                  OTotQty:=Qty*QtyMul;

                If (OTotQty=0) and (Not LastEdit) then
                  OTotQty:=1;

                With LId do
                  NTotQty:=Qty*QtyMul;

                {$IFDEF BoMObj}
                // MH 26/01/10: Re_CalcKitQty 'should' be unnecessary when the BoM Help object is
                // creating the lines as they 'should' be created with the correct quantities,
                // locations, etc...
                If Not oLineBoMHelper.Active Then
                {$ENDIF}
                Begin
                  If ((OTotQty<>NTotQty) or ((LastId.MLocStk<>LId.MLocStk) and (Syss.UseMLoc)))
                     and (LStock.StockType=StkBillCode) and (((LStock.ShowasKit) and (LId.IdDocHed In SalesSplit)) or
                       ((LStock.KitOnPurch) and (LId.IdDocHed In PurchSplit))) then
                    Re_CalcKitQty(OTotQty,NTotQty,LStock.StockFolio,LInv,LId);
                End;

                If (((LastId.QtyPick<>LId.QtyPick) or (LastId.PDate<>LId.PDate)) and (LId.IdDocHed In OrderSet)) then
                   Re_CalcKitOrd(LastId.QtyPick,LId.QtyPick,LId.Qty,LId.PDate,LStock.StockFolio,LId);
                //ABSEXCH-13257 RJha and HV If the last price is not updating in the Stock Analysis when transcation line record is getting Edited
                {$IFDEF PF_On}
                  BalLast:=InvLTotal(ExLocal.LastId,Not Syss.SepDiscounts,0);
                  BalNow:=InvLTotal(ExLocal.LId,Not Syss.SepDiscounts,0);
                  If (LastId.CustCode<>LId.CustCode) or (LastId.StockCode<>LId.StockCode)   or (BalLast <> BalNow)  then
                  Begin
                    Stock_AddCustAnal(LastId,BOn,1);
                    Stock_AddCustAnal(LId,BOn,0);
                  end;
                {$ENDIF}


              end;

              {$IFDEF SOP}

                If (LastId.Qty<>LId.Qty) then  {* Check SOP Link *}
                Begin
                  Update_SOPFLink(LastId,BOn,BOff,BOff,IDetailF,IdLinkK,KeyPath);

                  Update_SOPFLink(LId,BOff,BOff,BOn,IDetailF,IdLinkK,KeyPath);
                end;



                If ((Qty_OS(LastId)<>Qty_OS(LId)) or (LastId.PDate<>LId.PDate))
                then
                Begin
                  //PR 22/09/2008 Set IdStored to true here - if user clicked ok on header while line was
                  //updating commit, could get duplicate line.
                  IdStored:=BOn;
                  Update_LiveCommit(LastId,-1);
                  Update_LiveCommit(LId,1);
                end;

                {*v5.70, also resynch any change to locations *}

                //PR: 06/10/2011 Added check that the line value has changed ABSEXCH-11767
                If (LId.IdDocHed In StkInSet+StkOutSet) and (Syss.UseMLoc) and (LId.MLocStk<>LastId.MLocStk) and (SerialQty<>0.0) and (
                    not IsAverageCostMethod or LineValuesChanged) then
                Begin

                  UpdateSNos(LInv,LId,(LId.IdDocHed In SalesSplit-SalesCreditSet+PurchCreditSet));
                end;

              {$ENDIF}

            {$ENDIF}



            {$IFDEF PF_On}

              If (JbCostOn) and ((InvLLTotal(LId,BOn,0)<>0) or (InvLLTotal(LastId,BOn,0)<>0) or (LId.Qty<>0.0)) and (LId.KitLink=0) then
                Update_JobAct(LId,LInv);

              {.$IFNDEF JC}

                {* Check Over budget *}


                {$B-}

                With LId do
                Begin
                  Dnum:=DetLTotal(LId,BOn,BOff,0.0)*LineCnst(Payment);

                  If (JBCostOn) and ((LastId.AnalCode<>AnalCode) or (LastId.StockCode<>StockCode))
                    and (Not EmptyKey(JobCode,JobCodeLen))
                      and (Not Get_BudgMUp(JobCode,AnalCode,StockCode,0,Dnum,Dnum2, 2+Ord(IdDocHed In PSOPSet))) then

                    Warn_AnalOverB(JobCode,AnalCode);

                end; {With..}

                {$B+}

              {.$ENDIF}

              {$IFDEF STK}
                {$IFDEF Rp}

                  If (((LastId.QtyPick<>QtyPick) and (QtyPick<>0.0)) or ((LastId.Qty<>Qty) and (Qty<>0.0))) and (De4Page.TabVisible) and (Is_FullStkCode(StockCode))

                  {$IFDEF CU}
                    and  (ValidExitHook(4000,14,ExLocal))

                  {$ENDIF}   then

                  With LId do
                  Begin
                    // MH 07/02/2012 v6.10 ABSEXCH-10984: Added Account Code parameter so correct form definition set can be used
                    StkTransLab_Report(Self.Parent,FolioRef,ABSLineNo,13,(IdDocHed In [POR,SOR]), LInv.CustCode);

                  end;
                {$ENDIF}
              {$ENDIF}

            {$ENDIF}

            {$IFDEF SOP}

            if not (LastEdit and TransBeingEdited) then
               AddMultiBuyDescLines;
            {$ENDIF}
          end; //if not LViewOnly


          Status:=LPresrv_BTPos(Fnum,Keypath,F[Fnum],LastRecAddr[Fnum],BOn,BOff);

          Send_UpdateList(LastEdit,0);

        end;

        If (LastEdit) then
          ExLocal.UnLockMLock(Fnum,LastRecAddr[Fnum]);

        SetIdStore(BOff,BOff);

        IdStored:=BOn;

        { CJS 2013-08-06 - ABSEXCH-14210 - Access violation when storing Transaction }
        Cursor := CursorState;

        LastValueObj.UpdateAllLastValues(Self);



        {$IFDEF SOP}
          If (Assigned(TxAutoMLId)) then
            MLoc_GenLocSplit(Fnum,Keypath);
        {$ENDIF}

        PassStore:=BOn;

        Self.Close;

        Exit;

      end {* If ok2 store (}
      else
      Begin

        ChangePage(DefaultPage,BOff);

        SetFieldFocus;

        PassStore:=BOff;

      end;


    end; {With..}

  { CJS 2013-08-06 - ABSEXCH-14210 - Access violation when storing Transaction }
  finally
    Cursor := CursorState;
    OkCP1Btn.Enabled := ButtonState;
  end;

end;


procedure TTxLine.SetFieldProperties(Panel  :  TSBSPanel;
                                     Field  :  Text8Pt) ;

Var
  n  : Integer;


Begin
  For n:=0 to Pred(ComponentCount) do
  Begin
    If (Components[n] is TMaskEdit) or (Components[n] is TComboBox)
     or (Components[n] is TCurrencyEdit) then
    With TGlobControl(Components[n]) do
      If (Tag>0) then
      Begin
        Font.Assign(Field.Font);
        Color:=Field.Color;
      end;

    If (Components[n] is TBorCheck) then
      With (Components[n] as TBorCheck) do
      Begin
        {CheckColor:=Field.Color;}
        Color:=Panel.Color;
      end;

  end; {Loop..}


end;

{
  Parameters for different actions:

  Add:
    Edit: False
    InsMode: False
    ViewOnly: False

  Insert:
    Edit: False
    InsMode: True
    ViewOnly: False

  Edit:
    Edit: True
    InsMode: False
    ViewOnly: False

  View:
    Edit: True
    InsMode: False
    ViewOnly: True

}
procedure TTxLine.EditLine(InvR       :  InvRec;
                           Edit,
                           InsMode,
                           ViewOnly   :  Boolean);
begin
  With ExLocal do
  Begin
    LastEdit:=Edit;

    // CJS 2016-01-18 - ABSEXCH-17102 - 4.5 - Intrastat on Transaction Line
    if (not Edit) and (not InsMode) and (not ViewOnly) then
      FLineState := lsAdd
    else if InsMode then
      FLineState := lsInsert
    else if Edit and (not InsMode) and (not ViewOnly) then
      FLineState := lsEdit
    else
      FLineState := lsView;

    ShowLink(InvR,ViewOnly);

    ProcessId(IdetailF,CurrKeyPath^[IdetailF],LastEdit,InsMode);

    //PR: 23/08/2012 ABSEXCH-13333 Set previous line total for dealing with credit checks on edited lines.
    FPreviousLineTotal := LineTotalInBase;

     {$IFDEF SOP}
     //PR: 18/06/2009 Moved ShowMultiBuyDiscounts to here, as it was previously getting called even when cancelling.
      if (ExLocal.Lid.StockCode <> '') and (ActiveControl<>CanCP1Btn) and ExLocal.LastEdit and not TransBeingEdited then
      begin
        ShowMultiBuyDiscounts;
        UpdateMultiBuyDiscounts; //PR: 27/04/2009
      end;
     {$ENDIF}


    {$IFDEF SOP}
    if LastEdit and TransBeingEdited and not ExLocal.LViewOnly then  //Editing
    begin
      edtMultiBuy.ReadOnly := False;
      edtMultiBuy.TabStop := True;
      edtTransDiscount.ReadOnly := False;
      edtTransDiscount.TabStop := True;
    end
    else
    begin //Adding
      edtMultiBuy.ReadOnly := True;
      edtMultiBuy.TabStop := False;
      edtTransDiscount.ReadOnly := True;
      edtTransDiscount.TabStop := False;
    end;
    {$ENDIF}
  end;
end;

procedure TTxLine.SetHelpContextIDs(bInc : boolean);
// NF: 21/06/06 added new ids to differenciate between modes and to distinguish it from the main transaction window
var
  bPurchase : boolean;
  iOffSet : integer;

  procedure IncHelpContextIDs(iInc : integer; TheControl : TControl);
  var
    iPos : integer;

    procedure SetContextID(AControl : TControl; iNewID : integer);
    begin{SetContextID}
      // Exceptions
      if AControl is TTabSheet then exit;

      // Set Context ID
      if AControl.HelpContext > 0
      then AControl.HelpContext := iNewID;
    end;{SetContextID}

  begin{IncHelpContextIDs}
    // Inc the control's Context ID
    SetContextID(TheControl, TheControl.HelpContext + iInc);

    // Inc the Context IDs of the controls in the control
    For iPos := 0 to Thecontrol.ComponentCount -1 do
    begin
      if Thecontrol.Components[iPos] is TControl
      and (not (Thecontrol.Components[iPos] is TForm))
      then IncHelpContextIDs(iInc, TControl(TheControl.Components[iPos]));
    end;{for}
  end;{IncHelpContextIDs}

begin
  bPurchase := DocHed In PurchSplit;

  {$IFDEF LTE}
    // IAO
    if (not bHelpContextInc) and (not bInc) then exit;

    if bPurchase then iOffSet := 0
    else begin
      if bInc then
      begin
        iOffSet := 5000;
        bHelpContextInc := TRUE;
      end else
      begin
        iOffSet := -5000;
        bHelpContextInc := FALSE;
      end;{if}
    end;{if}

    // Set Correct Tab IDs
    if (bInc) then
    begin
      case PageControl1.ActivePage.PageIndex of
        0 : begin
          PageControl1.ActivePage.HelpContext := iOffSet + 1848;
        end;
        1 : begin
          PageControl1.ActivePage.HelpContext := iOffSet + 1851;
        end;
        2 : begin
          PageControl1.ActivePage.HelpContext := iOffSet + 1852;
        end;
        3 : begin
          PageControl1.ActivePage.HelpContext := iOffSet + 1853;
        end;
      end;{case}
    end;{if}

    if (iOffSet <> 0) then IncHelpContextIDs(iOffSet, Self);

    HelpContext := PageControl1.ActivePage.HelpContext;
    PageControl1.HelpContext := PageControl1.ActivePage.HelpContext;
  {$ELSE}
    // Exchequer
    // Fixes for incorrect Context IDs
    if bPurchase then
    begin
      Id1ItemF.HelpContext := 1854;
    end else
    begin
      Id1ItemF.HelpContext := 6854;
    end;{if}
  {$ENDIF}
end;

{$IFDEF SOP}
procedure TTxLine.ShowMultiBuyDiscounts;
var
  UDFieldsVisible : Boolean;
  UDPanelHeight,
  UDPanelTop : Integer;
begin
  //PR: 05/08/2009 Need to ignore BOM Lines (Id.KitLink <> 0).
  if (ExLocal.LastEdit and TransBeingEdited) or (Id.KitLink <> 0) then
    Exit;

  if Assigned(MBDFramesController) then
    FreeAndNil(MBDFramesController);

  MBDFramesController := TMBDFramesController.Create;
  MBDFramesController.OnValueChanged := DiscountValueChange;

  ClearMultiBuyDiscounts;
  with MBDFramesController do
  begin
    ExLocal := @Self.ExLocal;
    ScrollBox := scrMultiBuy;
    StartYPos := lblMultiBuy.Top + lblMultiBuy.Height + 8;
    IsSales := Self.ExLocal.LInv.InvDocHed in SalesSplit;
    HelpContext := scrMultiBuy.HelpContext;
    if AddMBDLineFrames(Self.ExLocal.LInv.CustCode, Self.ExLocal.LId.StockCode, Self.ExLocal.LInv.TransDate, Self.ExLocal.LInv.Currency) > 0 then
    begin
      StockCode := Self.ExLocal.LId.StockCode;
      scrMultiBuy.Visible := True;
    end
    else
    begin
      scrMultiBuy.Visible := False;
    end;
  end;

  SetButtonTops;
  SetFormHeight;
  UpdateMultiBuyDiscounts;
end;

procedure TTxLine.ClearMultiBuyDiscounts;
begin
  MBDFramesController.ClearFrames;
end;

procedure TTxLine.UpdateMultiBuyDiscounts;
var
  ThisQty : Double;
  TempQty : Double;
  iNewPage : Integer;
begin
  iNewPage := pcLivePage(PageControl1);
{  if iNewPage = 3 then
  begin
    if Assigned(MBDFramesController) then
      MBDFramesController.Enabled := False;
  end
  else}
  if not (ExLocal.LastEdit and TransBeingEdited) and Assigned(MBDFramesController) and (ActiveControl <> CanCP1Btn) then
  begin
    ThisQty := Ea2Case(ExLocal.LId, Stock, ExLocal.LId.Qty);
    MBDFramesController.EnableFrames(ThisQty);
    MBDFramesController.UpdateQuantities(ThisQty);

{    TempQty := ExLocal.LId.Qty;
    ExLocal.LId.Qty := Case2Ea(ExLocal.LId, Stock, ExLocal.LId.Qty);}
    MBDFramesController.UpdateValues(ExLocal.LId.Qty, ExLocal.LId.NetValue, ExLocal.LId);
//    ExLocal.LId.Qty := TempQty;


    DiscountValueChange(Self);
    //Fit MultiBuy panel into TabOrder
    SetBtnTab(PageControl1.ActivePageIndex);
{    if not Id3Panel3.Visible and Assigned(MBDFramesController.FirstEnabledEdit) then
      LineExtF1.TabNext := MBDFramesController.FirstEnabledEdit}
    MBDFramesController.Enabled := iNewPage <> 3;
  end;
end;

procedure TTxLine.ShowOrHideAdditionalDiscountTotals(bShow : Boolean);
begin
{  if bShow then
    Id3Panel2.Height := 202
  else
    Id3Panel2.Height := 129;}
end;

procedure TTxLine.DiscountValueChange(Sender : TObject);
var
  dValue : Double;
  cValue : Char;
begin
  //PR: 01/07/2009 Allow edit line as long as still adding transaction
  if Assigned(MBDFramesController) and not (TransBeingEdited and ExLocal.LastEdit) then
  begin
    //Update MultiBuy total
    MBDFramesController.GetUnitDiscountValue(dValue, cValue);
    ExLocal.LId.Discount2 := dValue;
    ExLocal.LId.Discount2Chr := cValue;
    OutId;
  end;
end;


procedure TTxLine.AddMultiBuyDescLines;
var
  LCount : Integer;
begin
  if Assigned(MBDFramesController) then
  begin
    if ExLocal.LastEdit then
      LCount := MBDFramesController.DeleteDescLines(ExLocal.LastId)
    else
      LCount := 0;
    // MH 02/11/2015 2016R1 ABSEXCH-16613: Re-instated SQL mod to improve performance when Exploding BoM's
	MBDFramesController.AddMultiBuyDiscountLines(ExLocal.LInv, ExLocal.LId, ExLocal.LStock.StockFolio, LCount, ExLocal.LastIns);
  end;
{  AList := MBDFramesController.GetDiscountLineStrings;
  Try
    if AList.Count > 0 then
    for i := 0 to AList.Count - 1 do
    begin
      FillChar(IDR, SizeOf(IDR), 0);
      Set_UpId(ExLocal.LId, IDR);
      IDR.LineNo:= ExLocal.LInv.ILineCount;
      IDR.ABSLineNo:=ExLocal.LInv.ILineCount;
      IDR.VatCode := ExLocal.LId.VatCode;
      Inc(ExLocal.LInv.ILineCount);

      IDR.Desc := AList[i];
      IDR.Qty := ExLocal.LId.Qty;
      IDR.QtyMul := ExLocal.LId.QtyMul;

      Res := Add_Rec(F[IDetailF], IDetailF, IDR, -1);
    end;
  Finally
    AList.Free;
  End;}
end;
{$ENDIF}


function TTxLine.ServicePanelHeight(OffSet : Integer = 0) : Integer;
begin
{  if pnlService.Visible then
    Result := pnlService.Height + 2 + Offset
  else}
    Result := 0;
end;

procedure TTxLine.SetButtonTops;
begin
end;

procedure TTxLine.SetFormHeight;
//PR: 08/02/2010 Changed this function to simplify it whilst adding Web Extensions fields
var
  iTotalPanelHeight : Integer;
begin
  SetPanelTops; //Set positions of MBDs, UDFs & Web Extensions

  //Find height of visible panels
  iTotalPanelHeight := PanelHeight(scrMultiBuy) +
                       PanelHeight(Id3Panel3) + //UD Fields
                       PanelHeight(pnlWebExtensions);

  if iTotalPanelHeight > 0 then
    PageControl1.Height := Id3Panel.Top +
                           Id3Panel.Height +
                           I_SPACER +
                           iTotalPanelHeight +
                           I_TABHEIGHT
  else
    //No panels visible, but need to allow room to show buttons
    PageControl1.Height := Id3Panel.Top +
                           Id3Panel.Height +
                           I_ROOM_FOR_BUTTONS +
                           I_TABHEIGHT;

  ClientHeight := PageControl1.Height;
end;

procedure TTxLine.LineExtF1Resize(Sender: TObject);
begin
  {$IFDEF SOP}
//   ShowOrHideAdditionalDiscountTotals(LineExtF1.Height > 134);
  {$ENDIF}
end;

procedure TTxLine.edtMultiBuyExit(Sender: TObject);
begin
  FFocusedControl := nil;
  Form2Id;
  OutId;
end;

procedure TTxLine.chkServiceClick(Sender: TObject);
begin
  dtServiceStart.Enabled := chkService.Checked;
  dtServiceEnd.Enabled := chkService.Checked;

  dtServiceStart.Color := IfThen(dtServiceStart.Enabled, Id3UPriceF.Color, clBtnFace);
  dtServiceStart.Font.Color := IfThen(dtServiceStart.Enabled, Id3UPriceF.Font.Color, clBtnShadow);
  dtServiceStart.Visible := False; dtServiceStart.Visible := True;

  lblServiceTo.Font.Color := Id3SCodeLab.Font.Color;

  dtServiceEnd.Font.Color := dtServiceStart.Font.Color;
  dtServiceEnd.Color := dtServiceStart.Color;
  dtServiceEnd.Visible := False; dtServiceEnd.Visible := True;
end;

procedure TTxLine.EnableECServiceCheckBox;

  function IsServiceStock : Boolean;
  begin
    {$IFDEF STK}
    Result := (Trim(Id3SCodeF.Text) = '') or
              (ExLocal.LStock.StockType = StkDescCode);
    {$ELSE}
    Result := True;
    {$ENDIF}
  end;

  function IsServiceVATCode : Boolean;
  begin
    with ExLocal do
    begin
      if LInv.InvDocHed in SalesSplit then
        Result := (LID.VATCode in ['D', '4']) //PR: 22/12/2009 Extended to allow VAT code 4 at request of MR
      else if (CurrentCountry = IECCode) then
        // CJS 2014-10-09 - ABSEXCH-15711 - Disable EC Services for invalid VAT Codes
        Result := (LID.VATCode in ['A', 'D'])
      else
        // MH 09/09/2009: Modified for useability so that services can be set before changing the VAT code
        Result := True; // not(LID.VATCode in ['A', 'D']);
    end;
  end;

  function IsServiceTrans : Boolean;
  begin
    with ExLocal do
      Result := (LInv.InvDocHed in SalesSplit - [SRC, SRN]) or  (LInv.InvDocHed in PurchSplit - [PPY, PRN]);
  end;

begin
  with ExLocal do
    chkService.Enabled := (Not ExLocal.LViewOnly) And LCust.EECMember and (LInv.SSDProcess In [#0, ' ']) And IsServiceTrans and IsServiceStock and IsServiceVATCode;

  if (Not ExLocal.LViewOnly) And (not chkService.Enabled) and chkService.Checked then
    chkService.Checked := False;

  chkService.Font.Color := IfThen(ExLocal.LViewOnly Or chkService.Enabled, Id3SCodeLab.Font.Color, clBtnShadow);

  chkServiceClick(Self);
end;

procedure TTxLine.chkServiceMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FServiceSet := True; //User
end;

procedure TTxLine.LineExtF1CloseUp(Sender: TObject);
{
  When the TSBSExtendedForm is 'rolled up' by the user clicking the arrow
  button, the OnExit event of any focused control is not triggered.

  To get round this, we are keeping track of the control which last had focus,
  setting this in the OnEnter and clearing it in the OnExit.

  This method is a callback from the TSBSExtendedForm and is called when it is
  rolled up. If the last focused control (FFocusedControl) is not nil, this must
  mean that the OnExit for that control was not called, so we call it here
  instead.

  -- CJS 21/09/2009
}
begin
  if (FFocusedControl <> nil) then
  begin
    if (FFocusedControl is TExt8Pt) then
    begin
      if Assigned((FFocusedControl as TExt8Pt).OnExit) then
        (FFocusedControl as TExt8Pt).OnExit(FFocusedControl as TExt8Pt);
    end
    else if (FFocusedControl is TCurrencyEdit) then
    begin
      if Assigned((FFocusedControl as TCurrencyEdit).OnExit) then
      begin
        (FFocusedControl as TCurrencyEdit).UnformatText;
        (FFocusedControl as TCurrencyEdit).FormatText;
        (FFocusedControl as TCurrencyEdit).OnExit(FFocusedControl as TCurrencyEdit);
      end;
    end
    else if (FFocusedControl is TSBSComboBox) then
    begin
      if Assigned((FFocusedControl as TSBSComboBox).OnExit) then
        (FFocusedControl as TSBSComboBox).OnExit(FFocusedControl as TSBSComboBox);
    end
    else if (FFocusedControl is TEditDate) then
    begin
      if Assigned((FFocusedControl as TEditDate).OnExit) then
      begin
        (FFocusedControl as TEditDate).ValidateEdit;
        (FFocusedControl as TEditDate).OnExit(FFocusedControl as TEditDate);
      end;
    end
  end;
end;

procedure TTxLine.Id3CostFDeleteMeExit(Sender: TObject);
begin
  FFocusedControl := nil;
end;

procedure TTxLine.edtMultiBuyEnter(Sender: TObject);
begin
  FFocusedControl := Sender as TWinControl;
end;

procedure TTxLine.edtTransDiscountEnter(Sender: TObject);
begin
  FFocusedControl := Sender as TWinControl;
end;

procedure TTxLine.Id3DelFDeleteEnter(Sender: TObject);
begin
  FFocusedControl := Sender as TWinControl;
end;

procedure TTxLine.Id3DelFDeleteExit(Sender: TObject);
begin
  FFocusedControl := nil;
end;

function TTxLine.PanelHeight(const oControl : TControl) : Integer;
//Returns height of panel according to its visibiltiy
begin
  if oControl.Visible then
    Result := oControl.Height + I_SPACER
  else
    Result := 0;
end;

procedure TTxLine.SetPanelTops;
//Sets Multi Buys, UDFs and Web Extensions panels in the correct position according to which ones are visible
const
  Spacer = 25; //Vertical space between new udfs

var
  VisibleUDFs, UdfStartPos, LabelStartPos : Integer; //Vertical start position of first new udf
  i, temp: Integer;
  Edits : Array[1..4] of TCustomEdit;
begin
  //Vertical positioning from top is Multi Buys, UDFs, Web Extensions. As Multi Buys is top, we only need to adjust
  //the positions of the lower two according to the visibility of the panel(s) above them.

  //User Defined Fields
  if Id3Panel3.Visible then
  begin
    if scrMultiBuy.Visible then //Put below MultiBuys
      Id3Panel3.Top := scrMultiBuy.Top + scrMultiBuy.Height + I_SPACER
    else //Put in place of MultiBuys
      Id3Panel3.Top := scrMultiBuy.Top;

    //UDF edits are on form rather than panel so need to be moved separately (labels are on the form.)
    LUD1F.Top := Id3Panel3.Top + 8;
    LUD3F.Top := LUD1F.Top;

    //Check if either of top two UDFs is visible
    if LUD1F.Visible or LUD3F.Visible then
    begin
      LUD2F.Top := LUD1F.Top + Spacer;
      UDF2L.Top := UDF1L.Top + Spacer;
    end
    else
    begin
      //Top 2 not visible move bottom ones up
      LUD2F.Top := LUD1F.Top;
      UDF2L.Top := UDF1L.Top;
    end;

    //Set udf4 to same top as udf2
    LUD4F.Top := LUD2F.Top;
    UDF4L.Top := UDF2L.Top;

    //Check if left vertical column visible - if not then move right column to position of left
    if not UDF1L.Visible and not UDF2L.Visible then
    begin
      //Move UDFs 3 & 4 to left
      UDF3L.Left := UDF1L.Left;
      LUD3F.Left := LUD1F.Left;

      UDF4L.Left := UDF2L.Left;
      LUD4F.Left := LUD2F.Left;
    end;
  end;

  //PR: 13/10/2011 Added new user fields for 6.9
  if not (LUD1F.Visible or LUD3F.Visible or LUD2F.Visible or LUD4F.Visible) then
  begin
    UdfStartPos := Id3Panel3.Top + 8;
    LabelStartPos := 14;
  end
  else
  begin
    //GS: this works if both rows of the orig UDFs are visible
    UdfStartPos := LUD2F.Top + 37;
    LabelStartPos := UDF2L.Top + 37;

    //get a handle on the orig UDFs
    Edits[1] := LUD1F;
    Edits[2] := LUD2F;
    Edits[3] := LUD3F;
    Edits[4] := LUD4F;

    //get a count on the number that are visible
    VisibleUDFs := NumberOfVisibleUDFs(Edits);

    //if there is only 1 visible, shift the new UDFs up one row to take up the blank space
    if VisibleUDFs = 1 then
    begin
      UdfStartPos := LUD1F.Top + 37;
      LabelStartPos := UDF1L.Top + 37;
    end

    //however if two are visible..
    else if VisibleUDFs = 2 then
    begin
      //assume that we want to shift the new UDFs up a row
      UdfStartPos := LUD1F.Top + 37;
      LabelStartPos := UDF1L.Top + 37;

      //now we will check to see if the two visible UDFs are taking up more than 1 row
      for i := 1 to 4 do
      begin
        //check to see if this UDF is on the first row
        if (Edits[i].visible = true) and (Edits[i].top <> Edits[1].top) then
        begin
          //the UDF is not on the first row so dont shift the new UDFs up an extra column
          //notice we are offsetting the position of the new UDFs from LUD2F, not LUD1F
          UdfStartPos := LUD2F.Top + 37;
          LabelStartPos := UDF2L.Top + 37;
        end;//end if
      end;//end for

    end;//end if

  end;
  edtUdf5.Top := UdfStartPos;
  lblUdf5.Top := LabelStartPos;

  edtUdf6.Top := edtUdf5.Top + Spacer;
  lblUdf6.Top := lblUdf5.Top + Spacer;

  edtUdf7.Top := edtUdf6.Top + Spacer;
  lblUdf7.Top := lblUdf6.Top + Spacer;

  edtUdf8.Top := edtUdf5.Top;
  lblUdf8.Top := lblUdf5.Top;

  edtUdf9.Top := edtUdf6.Top;
  lblUdf9.Top := lblUdf6.Top;

  edtUdf10.Top := edtUdf7.Top;
  lblUdf10.Top := lblUdf7.Top;

  //Now that new udfs have the correct positions, we can adjust for any hidden ones.
  ArrangeUDfs([lblUdf5, lblUdf6, lblUdf7, lblUdf8, lblUdf9, lblUdf10], [edtUdf5, edtUdf6, edtUdf7, edtUdf8, edtUdf9, edtUdf10]);

  //Web Extensions
  if pnlWebExtensions.Visible then
  begin
    if Id3Panel3.Visible then //Put below UDFs
      pnlWebExtensions.Top := Id3Panel3.Top + Id3Panel3.Height + I_SPACER
    else
    begin
      if scrMultiBuy.Visible then //Put below MultiBuys
        pnlWebExtensions.Top := scrMultiBuy.Top + scrMultiBuy.Height + I_SPACER
      else //Put in place of MultiBuys
        pnlWebExtensions.Top := scrMultiBuy.Top;
    end;
  end;
end;

procedure TTxLine.ResetTabOrder;
var
  i : integer;
begin
//On an order, if we tab back to the data entry tab after using the qty/pick tab, the tab order is screwed - this should put
//the controls back in order again.

//PR: 13/10/2011 Added new user fields for 6.9
  i := 18;
  pnlWebExtensions.TabOrder := i;
  edtUdf10.TabOrder := i - 1;
  edtUdf9.TabOrder := i - 2;
  edtUdf8.TabOrder := i - 3;
  edtUdf7.TabOrder := i - 4;
  edtUdf6.TabOrder := i - 5;
  edtUdf5.TabOrder := i - 6;
  LUD4F.TabOrder := i - 7;
  LUD3F.TabOrder := i - 8;
  LUD2F.TabOrder := i - 9;
  LUD1F.TabOrder := i - 10;
  Id3Panel3.TabOrder := i-11;
  scrMultiBuy.TabOrder := i-12;
  pnlValues.TabOrder := i-13;

end;

procedure TTxLine.SetCoreValues;
var
  iShiftBy, i : Integer;
begin
  iShiftBy := Bevel1.Left;
  for i := 0 to pnlValues.ControlCount - 1 do
  begin
    if pnlValues.Controls[i].Left <= iShiftBy then
    begin
       pnlValues.Controls[i].Visible := False;
       if pnlValues.Controls[i] is TWinControl then
       (pnlValues.Controls[i] as TWinControl).TabStop := False;
    end
    else
      pnlValues.Controls[i].Left := pnlValues.Controls[i].Left - iShiftBy;
  end;
  pnlValues.Width := De1Page.Width - (Id1Panel.Left + Id1Panel.Width + 4);
  pnlValues.Left :=  Id1Panel.Left + Id1Panel.Width + 2;
  Bevel1.Visible := False;
end;
//===========================================================================================
//PR: 06/10/2011 Functions to ensure that we don't update average costs unless the line value, qty or stock code/location has changed. ABSEXCH-11767

function TTxLine.GetLineValue : Double;
begin
  //This is only called after line values have been displayed, so
  //we can get the total from the edit fields.
  Result := Id3LTotF.Value;

  //If it's a purchase transaction then we need to include any uplift
  if ExLocal.LId.IdDocHed in PurchSplit then
    Result := Result + Id3CostF.Value;
end;

function TTxLine.GetLineQty : Double;
begin
  //This is only called after line values have been displayed, so
  //we can get the total from the edit fields - Qty * PackQty.
  Result := Id3QtyF.Value;

  if Id3PQtyF.Value > 1 then
    Result := Result * Id3PQtyF.Value;

end;

function TTxLine.LineValuesChanged : Boolean;
begin
  //LastEdit indicates that we're editing. If we're adding then value has obviously changed
  Result := not ExLocal.LastEdit;

  if not Result then //Editing, so check agains value stored when we displayed the form.
    Result := (FOriginalLineValue <> GetLineValue) or (FOriginalLineQty <> GetLineQty) or
              (FOriginalPickQty <> ExLocal.LId.QtyPick) or
              (FOriginalStockCode <> ExLocal.LId.StockCode + ExLocal.LId.MLocStk);
end;

function TTxLine.IsAverageCostMethod : Boolean;
begin
  with ExLocal.LStock do
    Result := (StkValType = 'A') or ((StkValType = 'R') and (SerNoWAvg = 1));
end;

//PR: 02/08/2012 ABSEXCH-12746 Function to specify whether the user can pick items on a sales order
function TTxLine.AllowPicking : Boolean;
var
  CantPick : Boolean;
  PlusTotal : Double;
  MinusTotal : Double;
  WTrigger : Boolean;
  NeedToCheck : Boolean;
  CreditHold : Boolean;
begin
  {$IFNDEF SOP}
   Result := True;
  {$ELSE}
  CantPick := False;
  CreditHold := False;

  with ExLocal do
  begin
    //On SORs only, if account on hold and picked qty has been increased we stop user picking.
    //PR: 23/01/2012 ABSEXCH-13916 Allow stop picking to be overridden if transaction is authorised.
    NeedToCheck := (LId.IdDocHed = SOR) and (ID4QPTF.Value > LastId.QtyPick) and (ExLocal.LInv.HoldFlg and 7 <> 3);


    if NeedToCheck then
    begin
      //Customer on hold
      CantPick := AccountOnHold(LCust);

      if not CantPick then
      begin

        //PR: 10/08/2015 ABSEXCH-16388 If order has been fully paid then allow picking
        if not OrderIsFullyPaid(ExLocal.LInv) then
        begin

          //Check that value of transaction doesn't go over customer's credit limit.
          WTrigger := False;
          if TransBeingEdited then
          begin
            MinusTotal := FPreviousOrderTotal;
            PlusTotal :=  ConvCurrOrderTotal(LInv, UseCoDayRate, True) - FPreviousLineTotal + LineTotalInBase;
          end
          else
          begin
            MinusTotal := 0;
            PlusTotal :=  ConvCurrOrderTotal(LInv, UseCoDayRate, True) + LineTotalInBase;
          end;

          //PR: 08/02/2013 ABSEXCH-13987 Added check for Use Credit Status flag - don't stop picking unless that is set.
          CantPick := Check_AccForCredit(LCust, PlusTotal, MinusTotal, True, True, WTrigger, Self) or (WTrigger and Syss.UseCreditChk);


          CreditHold := CantPick;
        end; //if not OrderIsFullyPaid(ExLocal.LInv)
      end;
    end;
  end;

  Result := not CantPick;

  //Display warning if required and reset qty pick field.
  if CantPick then
  begin
    DisplayCantPickWarning(CreditHold);
    ID4QPTF.Value := ExLocal.LastId.QtyPick;
  end;
  {$ENDIF}
end;

//PR: 23/08/2012 ABSEXCH-13333
function TTxLine.LineTotalInBase : Double;
var
  TmpId : IDetail;
begin
  with ExLocal do
  begin
    Result := Conv_Curr(InvLTotal(LId,Syss.ShowInvDisc, LInv.DiscSetl*Ord(LInv.DiscTaken)),
                                           XRate(LInv.CXRate, UseCoDayRate, LInv.Currency), False);

    //InvLTotal doesn't include VAT, so if we're using it for committed balances we need to add it.
    if Syss.IncludeVATInCommittedBalance then
    begin
      TmpId := LId;
      CalcVAT(TmpId, 0);
      Result := Result + TmpId.VAT;
    end;
  end;
end;

procedure TTxLine.chkOverrideIntrastatClick(Sender: TObject);
begin
  // CJS 2016-01-14 - ABSEXCH-17102 - 4.5 - Intrastat on Transaction Line
  EnableIntrastat(chkOverrideIntrastat.Checked);
  if not ExLocal.LId.SSDUseLine then
    SetDefaultIntrastatDetails;
end;

procedure TTxLine.chkCountryClick(Sender: TObject);
begin
  cbIntrastatCountry.Enabled := True;
end;

procedure TTxLine.chkQRCodeClick(Sender: TObject);
begin
  cbIntrastatCountry.Enabled := False;
end;

procedure TTxLine.Id3VATFDropDown(Sender: TObject);
begin
  // SSK 22/06/2017 2017-R1 ABSEXCH-13530 : this change will force a Id3VATFClick event for Inclusive VAT selection
  if Id3VATF.Items[Id3VATF.ItemIndex][1] in ['I', 'M'] then
    Id3VATF.ItemIndex := 0;

end;

procedure TTxLine.EnableEditPostedFields;
begin
  FAllowPostedEdit := True;

  //Description lines
  Id1Desc1F.AllowPostedEdit := True;
  Id1Desc2F.AllowPostedEdit := True;
  Id1Desc3F.AllowPostedEdit := True;
  Id1Desc4F.AllowPostedEdit := True;
  Id1Desc5F.AllowPostedEdit := True;
  Id1Desc6F.AllowPostedEdit := True;

  Id3Desc1F.AllowPostedEdit := True;
  Id3Desc2F.AllowPostedEdit := True;
  Id3Desc3F.AllowPostedEdit := True;
  Id3Desc4F.AllowPostedEdit := True;
  Id3Desc5F.AllowPostedEdit := True;
  Id3Desc6F.AllowPostedEdit := True;

  //Udfs
  LUD1F.AllowPostedEdit := True;
  LUD2F.AllowPostedEdit := True;
  LUD3F.AllowPostedEdit := True;
  LUD4F.AllowPostedEdit := True;
  edtUDF5.AllowPostedEdit := True;
  edtUDF6.AllowPostedEdit := True;
  edtUDF7.AllowPostedEdit := True;
  edtUDF8.AllowPostedEdit := True;
  edtUDF9.AllowPostedEdit := True;
  edtUDF10.AllowPostedEdit := True;

end;

function TTxLine.TransactionViewOnly : Boolean;
begin
  Result := ExLocal.LViewOnly and not FAllowPostedEdit;
end;



Initialization

end.




