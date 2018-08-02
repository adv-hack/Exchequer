unit TranSOPF;

{$ALIGN 1}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TCustom, Menus, ExtCtrls, SBSPanel, StdCtrls, TEditVal, Math,
  AccelLbl, Buttons, BorBtns, bkgroup, Mask, ComCtrls, StrUtils,
  GlobVar,       // Exchequer global const/type/var
  VarConst,      // Exchequer global const/type/var
  SBSComp,       // Btrieve List Routines
  SupListU,      // Btrieve List Classes (TGenList)
  SBSComp2,      // Routines for Loading/Saving Window Colours/Co-Ordinates
  ExWrap1U,      // Btrieve File Wrapper Object
  BTRVU2,
  PayLineU,      // Copy of Exchequer PayLineU - Payment Line window
  SOPLineF,      // Transaction Line form
  VATMatrx,      // VAT Matrix Class (Copied from SalTxl1U)
  BTSupU1;       // Custom Messages and Misc Btrieve Routines

type
  // MH 24/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
  EnumSetDiscSavedPositions = (SetDiscOriginalFrameWidth = 1,
                               SetDiscOriginalFrameHeight = 2,
                               SetDiscOriginalFieldLeft = 3,
                               SetDiscOriginalLabelWidth = 4);

  //------------------------------

  TTransMList  =  Class(TGenList)
  Public
    DayBkListMode      : Byte;
    Rnum, Rnum2        : Double;

    Function SetCheckKey : Str255; Override;
    Function SetFilter   : Str255; Override;
    Function OutLine(Col : Byte) : Str255; Override;
  End; { TTransMList }

  //------------------------------


  TfrmSOPTrans = class(TForm)
    PageControl1: TPageControl;
    MainPage: TTabSheet;
    I1SBox: TScrollBox;
    I1QtyPanel: TSBSPanel;
    I1StkCodePanel: TSBSPanel;
    I1DescPanel: TSBSPanel;
    I1LTotPanel: TSBSPanel;
    I1UPricePanel: TSBSPanel;
    I1VATPanel: TSBSPanel;
    I1HedPanel: TSBSPanel;
    I1SCodeLab: TSBSPanel;
    I1QtyLab: TSBSPanel;
    I1UPLab: TSBSPanel;
    I1DiscLab: TSBSPanel;
    I1VATLab: TSBSPanel;
    I1DescLab: TSBSPanel;
    I1LTotLab: TSBSPanel;
    I1ItemLab: TSBSPanel;
    I1DiscPanel: TSBSPanel;
    I1ItemPanel: TSBSPanel;
    I1ListBtnPanel: TSBSPanel;
    I1BtmPanel: TSBSPanel;
    Label813: Label8;
    I1CCLab: Label8;
    I1DepLab: Label8;
    I1LocnLab: Label8;
    Label819: Label8;
    I1VATTLab: Label8;
    Label821: Label8;
    CurrLab1: Label8;
    I1NomCodeF: Text8Pt;
    I1CCF: Text8Pt;
    I1DepF: Text8Pt;
    I1LocnF: Text8Pt;
    INetTotF: TCurrencyEdit;
    IVATTotF: TCurrencyEdit;
    IGTotF: TCurrencyEdit;
    AnalPage: TTabSheet;
    Label829: Label8;
    I2SBox: TScrollBox;
    I2LocnPanel: TSBSPanel;
    I2StkCodePanel: TSBSPanel;
    I2DelDatePanel: TSBSPanel;
    I2NomPanel: TSBSPanel;
    I2CCPanel: TSBSPanel;
    I2HedPanel: TSBSPanel;
    I2SCodeLab: TSBSPanel;
    I2LocnLab: TSBSPanel;
    I2NomLab: TSBSPanel;
    I2MargLab: TSBSPanel;
    I2DelLab: TSBSPanel;
    I2CCLab: TSBSPanel;
    I2DepLab: TSBSPanel;
    I2NValLab: TSBSPanel;
    I2CostLab: TSBSPanel;
    I2GPLab: TSBSPanel;
    I2NetValPanel: TSBSPanel;
    I2DepPanel: TSBSPanel;
    I2CostPanel: TSBSPanel;
    I2MargPanel: TSBSPanel;
    I2GPPanel: TSBSPanel;
    I2BtmPanel: TSBSPanel;
    I2StkDescLab: Label8;
    I2QtyLab: Label8;
    Label833: Label8;
    I1MargLab: Label8;
    I1GPLab: Label8;
    I2StkDescF: Text8Pt;
    I2QtyF: TCurrencyEdit;
    QtyPPage: TTabSheet;
    I3SBox: TScrollBox;
    I3StkDPanel: TSBSPanel;
    I3HedPanel: TSBSPanel;
    I3StkDLab: TSBSPanel;
    I3QOrdLab: TSBSPanel;
    I3DelLab: TSBSPanel;
    I3QWOLab: TSBSPanel;
    I3QOSLab: TSBSPanel;
    I3QPKLab: TSBSPanel;
    I3QTWLab: TSBSPanel;
    I3QOrdPanel: TSBSPanel;
    I3QDelPanel: TSBSPanel;
    I3QWOPanel: TSBSPanel;
    I3QOSPanel: TSBSPanel;
    I3QPKPanel: TSBSPanel;
    I3QTWPanel: TSBSPanel;
    I3BtmPanel: TSBSPanel;
    I3StkCodeLab: Label8;
    I3CCLab: Label8;
    I3DepLab: Label8;
    I3LocnLab: Label8;
    Label826: Label8;
    I2VATTLab: Label8;
    Label828: Label8;
    I3StkCodeF: Text8Pt;
    I3CCF: Text8Pt;
    I3DepF: Text8Pt;
    I3LocnF: Text8Pt;
    JobPage: TTabSheet;
    I4SBox: TScrollBox;
    I4JCPanel: TSBSPanel;
    I4StkDPanel: TSBSPanel;
    I4LTotPanel: TSBSPanel;
    I4HedPanel: TSBSPanel;
    I4StkDLab: TSBSPanel;
    I4JCLab: TSBSPanel;
    I4LtotLab: TSBSPanel;
    I4JALab: TSBSPanel;
    I4StkCLab: TSBSPanel;
    I4JAPanel: TSBSPanel;
    I4StkCPanel: TSBSPanel;
    I4BtmPanel: TSBSPanel;
    Label87: Label8;
    I3VATTLab: Label8;
    Label811: Label8;
    Label830: Label8;
    I4CCLab: Label8;
    I4DepLab: Label8;
    I4NomF: Text8Pt;
    I4CCF: Text8Pt;
    I4DepF: Text8Pt;
    FootPage: TTabSheet;
    SBSPanel53: TSBSPanel;
    Label834: Label8;
    I5VRateL: TLabel;
    SBSPanel54: TSBSPanel;
    I5VATRLab: TLabel;
    Label8: TLabel;
    I5VATLab: TLabel;
    ScrollBox8: TScrollBox;
    I5VR1F: Text8Pt;
    I5VR2F: Text8Pt;
    I5VR3F: Text8Pt;
    I5VR4F: Text8Pt;
    I5VR5F: Text8Pt;
    I5VR6F: Text8Pt;
    I5VR7F: Text8Pt;
    I5VG1F: TCurrencyEdit;
    I5VG2F: TCurrencyEdit;
    I5VG3F: TCurrencyEdit;
    I5VG4F: TCurrencyEdit;
    I5VG5F: TCurrencyEdit;
    I5VG6F: TCurrencyEdit;
    I5VG7F: TCurrencyEdit;
    I5VV1F: TCurrencyEdit;
    I5VV2F: TCurrencyEdit;
    I5VV3F: TCurrencyEdit;
    I5VV4F: TCurrencyEdit;
    I5VV5F: TCurrencyEdit;
    I5VV6F: TCurrencyEdit;
    I5VV7F: TCurrencyEdit;
    I5VR8F: Text8Pt;
    I5VG8F: TCurrencyEdit;
    I5VV8F: TCurrencyEdit;
    I5Vr9F: Text8Pt;
    I5VG9F: TCurrencyEdit;
    I5VV9F: TCurrencyEdit;
    I5Vr10F: Text8Pt;
    I5VG10F: TCurrencyEdit;
    I5VV10F: TCurrencyEdit;
    I5Vr11F: Text8Pt;
    I5VG11F: TCurrencyEdit;
    I5VV11F: TCurrencyEdit;
    I5VR12F: Text8Pt;
    I5VG12F: TCurrencyEdit;
    I5VV12F: TCurrencyEdit;
    I5Vr13F: Text8Pt;
    I5VG13F: TCurrencyEdit;
    I5VV13F: TCurrencyEdit;
    I5Vr14F: Text8Pt;
    I5VG14F: TCurrencyEdit;
    I5VV14F: TCurrencyEdit;
    I5Vr15F: Text8Pt;
    I5VG15F: TCurrencyEdit;
    I5VV15F: TCurrencyEdit;
    I5VV16F: TCurrencyEdit;
    I5VG16F: TCurrencyEdit;
    I5Vr16F: Text8Pt;
    I5Vr17F: Text8Pt;
    I5VG17F: TCurrencyEdit;
    I5VV17F: TCurrencyEdit;
    I5VV18F: TCurrencyEdit;
    I5VG18F: TCurrencyEdit;
    I5Vr18F: Text8Pt;
    I5Vr19F: Text8Pt;
    I5VG19F: TCurrencyEdit;
    I5VV19F: TCurrencyEdit;
    I5Vr20F: Text8Pt;
    I5VG20F: TCurrencyEdit;
    I5VV20F: TCurrencyEdit;
    I5Vr21F: Text8Pt;
    I5VG21F: TCurrencyEdit;
    I5VV21F: TCurrencyEdit;
    DMDCNomF: Text8Pt;
    I5VRateF: TCurrencyEdit;
    PayPage: TTabSheet;
    RCSBox: TScrollBox;
    RcHedPanel: TSBSPanel;
    RcNLab: TSBSPanel;
    RcBLab: TSBSPanel;
    RcDLab: TSBSPanel;
    RcPLab: TSBSPanel;
    RcQLab: TSBSPanel;
    RcRLab: TSBSPanel;
    RcPPanel: TSBSPanel;
    RcNPanel: TSBSPanel;
    RCDPanel: TSBSPanel;
    RcBPanel: TSBSPanel;
    RcQPanel: TSBSPanel;
    RcRPanel: TSBSPanel;
    RcListBtnPanel: TSBSPanel;
    I6BtmPanel: TSBSPanel;
    Label83: Label8;
    Label85: Label8;
    Label86: Label8;
    I1BtnPanel: TSBSPanel;
    I1BSBox: TScrollBox;
    I1FPanel: TSBSPanel;
    Label84: Label8;
    I1CurrLab: Label8;
    lblAcCode: Label8;
    I1ExLab: Label8;
    Label88: Label8;
    Label817: Label8;
    I1DelBtn: TSpeedButton;
    I1DueDateL: Label8;
    SBSAccelLabel1: TSBSAccelLabel;
    I1OurRefF: Text8Pt;
    I1OpoF: Text8Pt;
    I1AccF: Text8Pt;
    I1TransDateF: TEditDate;
    I1DueDateF: TEditDate;
    I1EXRateF: TCurrencyEdit;
    I1PrYrF: TEditPeriod;
    I1CurrF: TSBSComboBox;
    I1DumPanel: TSBSPanel;
    FixXRF: TBorCheck;
    TransExtForm1: TSBSExtendedForm;
    I4JobCodeL: Label8;
    I4JAnalL: Label8;
    I1YrRefL: Label8;
    I1YrRef2L: Label8;
    UDF1L: Label8;
    UDF3L: Label8;
    UDF2L: Label8;
    UDF4L: Label8;
    Label822: Label8;
    Label823: Label8;
    Label824: Label8;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    I5NBL: Label8;
    THUD1F: Text8Pt;
    THUD3F: Text8Pt;
    THUD4F: Text8Pt;
    THUD2F: Text8Pt;
    ISDelF: Text8Pt;
    ISTTF: TCurrencyEdit;
    ISMTF: TCurrencyEdit;
    ISPTF: TSBSComboBox;
    I1YrRefF: Text8Pt;
    I1YrRef2F: Text8Pt;
    I4JobCodeF: Text8Pt;
    I4JobAnalF: Text8Pt;
    I5NBF: TCurrencyEdit;
    PopupMenu1: TPopupMenu;
    PropFlg: TMenuItem;
    N1: TMenuItem;
    StoreCoordFlg: TMenuItem;
    N3: TMenuItem;
    btnViewLine: TButton;
    ClsI1Btn: TButton;
    I1StatLab: Label8;
    View1: TMenuItem;
    CISPanel1: TSBSPanel;
    CISBackGroup1: TSBSBackGroup;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    I5CISTaxF: TCurrencyEdit;
    I5CISManCb: TBorCheck;
    I5CISDecF: TCurrencyEdit;
    I5CISPeriodF: TEditDate;
    I5CISGrossF: TCurrencyEdit;
    bevBelowOverrideLocation: TBevel;
    lblOverrideLocation: Label8;
    edtOverrideLocation: Text8Pt;
    THUD5F: Text8Pt;
    THUD7F: Text8Pt;
    THUD9F: Text8Pt;
    THUD6F: Text8Pt;
    THUD8F: Text8Pt;
    THUD10F: Text8Pt;
    UDF5L: Label8;
    UDF7L: Label8;
    UDF9L: Label8;
    UDF6L: Label8;
    UDF8L: Label8;
    UDF10L: Label8;
    I1AddrF: TMemo;
    I5MVATF: TCheckBox;
    Label9: TLabel;
    Bevel4: TBevel;
    lvLineTypeTotals: TListView;
    ClsI5Btn: TButton;
    nbSettleDisc: TNotebook;
    SBSPanel55: TSBSBackGroup;
    Label5: TLabel;
    Label6: TLabel;
    Label4: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label20: TLabel;
    Label19: TLabel;
    Label18: TLabel;
    Label17: TLabel;
    I5SDPF: TCurrencyEdit;
    I5SDDF: TCurrencyEdit;
    I5Net1F: TCurrencyEdit;
    I5VAT1F: TCurrencyEdit;
    I5Disc1F: TCurrencyEdit;
    I5Tot1F: TCurrencyEdit;
    I5Net2F: TCurrencyEdit;
    I5VAT2F: TCurrencyEdit;
    I5Disc2F: TCurrencyEdit;
    I5Tot2F: TCurrencyEdit;
    SBSPanel62: TSBSPanel;
    Label13: TLabel;
    SBSPanel63: TSBSPanel;
    Label21: TLabel;
    I5SDTF: TCheckBox;
    lblPromptPaymentDiscountHeader: TLabel;
    lblPPDPercentage: TLabel;
    lblPPDPercentagePercent: TLabel;
    lblPPDDays: TLabel;
    bevPromptPaymentDiscountHeader: TBevel;
    Label22: TLabel;
    Bevel5: TBevel;
    shapePPDStatus: TShape;
    lblPPDStatus: TLabel;
    ccyPPDPercentage: TCurrencyEdit;
    ccyPPDDays: TCurrencyEdit;
    lvTransactionTotalsPPD: TListView;
    Label10: TLabel;
    Bevel6: TBevel;
    lvTransactionTotals: TListView;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormResize(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure PageControl1Changing(Sender: TObject; var AllowChange: Boolean);
    procedure PropFlgClick(Sender: TObject);
    procedure StoreCoordFlgClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure ClsI1BtnClick(Sender: TObject);
    procedure btnViewLineClick(Sender: TObject);
  private
    { Private declarations }
    ExLocal     : TdExLocal;

    MULCtrlO    : TTransMList;
    MULVisiList : Array[0..3] of TVisiList;

    PayCtrl     : TPayLine;        // Payment Details Line form
    IdLine      : TfrmSOPLine;     // Standard transaction Line form

    GotCoord    : Boolean;
    InitSize    : TPoint;
    LastCoord   : Boolean;
    ListOfSet   : Integer;
    NeedCUpdate : Boolean;
    PagePoint   : Array[0..6] of TPoint;
    ReCalcTot   : Boolean;
    SetDefault  : Boolean;
    StartSize   : TPoint;
    StoreCoord  : Boolean;
    VATMatrix   : TVATMatrix;

    // MH 24/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
    SavedSettleDiscPos : Array [EnumSetDiscSavedPositions] of Integer;

    procedure BuildDesign;
    Procedure ChangeList (PageNo : Byte; ShowLines : Boolean);
    Function  Current_BarPos (Const PageNo : Byte) : Integer;
    Function  Current_Page : Integer;
    procedure Display_Id (Const TheId : IDetail; Const DataChanged : Boolean);
    procedure Find_FormCoord;
    procedure FormBuildList (ShowLines : Boolean);
    procedure FormDesign;
    procedure FormSetOfSet;
    procedure HidePanels (PageNo : Byte);
    Procedure InitVisiList (PageNo : Byte);
    Procedure Link2Nom;
    Procedure OutInvFooterTot;
    Procedure OutInvTotals (Const NewIndex : Integer);
    procedure ReFreshFooter;
    procedure RefreshList (ShowLines, IgMsg : Boolean);
    Procedure SetColDec (PageNo : Byte);
    Procedure SetCurrent_BarPos(Const PageNo : Byte; Const NewBO : Integer);
    procedure SetFieldProperties;
    procedure SetFormProperties(SetList  :  Boolean);
    procedure SetInvFields;
    Procedure SetInvTotPanels (Const NewIndex : Integer);
    procedure SetUDFields(UDDocHed  :  DocTypes);
    procedure Store_FormCoord (UpMode : Boolean);
    procedure Store_Page1Coord(UpMode  :  Boolean);
    Procedure WMCustGetRec (Var Message : TMessage); Message WM_CustGetRec;
    procedure WMWindowPosChanged(var Msg : TMessage); Message WM_WindowPosChanged;

    // CJS 2013-11-27 - MRD1.1.17 - Consumer Support
    procedure ResizeAcCodeField(ForConsumer: Boolean);

    // MH 26/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
    Procedure ShowSettlementDiscountFields (Const ShowFields : Boolean);

    // MH 19/05/2015 v7.0.14 ABSEXCH-16284: Hide PPD fields for non-qualifying transactions or if disabled on the account
    Function ShowPPDFields : Boolean;
    // MH 19/05/2015 v7.0.14 ABSEXCH-16284: Hide PPD fields for non-qualifying transactions or if disabled on the account
    Procedure DisplayPPDFields;
    // MH 19/05/2015 v7.0.14 ABSEXCH-16284: Hide PPD fields for non-qualifying transactions or if disabled on the account
    Procedure UpdatePPDStatusInfo;
  public
    { Public declarations }
    procedure DisplayTrans (Const TheTrans : InvRec; Const TheCust : CustRec);
  end;

var
  frmSOPTrans: TfrmSOPTrans;

implementation

{$R *.dfm}

Uses
  ETStrU,
  ETDateU,
  ETMiscU,
  CmpCtrlU,       // Misc Routines for loading/saving Colours & Positions
  ColCtrlU,       // Form Color/Font Properties Window
  DispDocF,       // Transaction Display Manager and some common routines
  EntData,        // Global Exchequer Data object
  EntLicence,     // Global Exchequer Licence object
  CurrncyU,       // Misc Exchequer Currency Routines
  ComnUnit,       // Misc Exchequer Period and Transaction Total Routines
  Comnu2,         // Misc Exchequer Routines
  IntStatU,       // Misc Intrastat
  InvFSu3U,       // Misc utility functions
  MiscU,          // Transaction Total Functions
  SysU2,
  BTSupU2,        // Misc Exchequer Routines
  BTKeys1U,       // Exchequer Search Key utilities
  CustomFieldsIntf,   // Custom Fields Info Object
  { CJS - 2013-10-25 - MRD2.6.05 - ABSEXCH-14705 - Transaction Originator }
  TransactionOriginator,
  // MH 23/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
  TransactionHelperU,

  // MH 19/05/2015 v7.0.14 ABSEXCH-16284: Hide PPD fields for non-qualifying transactions or if disabled on the account
  PromptPaymentDiscountFuncs;

Const
  SettleDiscPage = 0;
  PromptPaymentDiscountPage = 1;
  NoPromptPaymentDiscountPage = 2;

//=========================================================================

Function TTransMList.SetCheckKey : Str255;
Var
  DumStr : Str255;
  TmpLNo : LongInt;
Begin { SetCheckKey }
  FillChar (DumStr, Sizeof(DumStr), 0);

  With Id Do
  Begin
    Case Keypath of
      IdFolioK   : Begin
                     If (UseSet4End) and (CalcEndKey) then  {* If A special end key calculation is needed *}
                       TmpLNo:=MaxLInt
                     Else
                       TmpLNo:=LineNo;

                     DumStr:=FullIdKey(FolioRef,TmpLNo);
                   End;
    End; { Case Keypath }
  End; { With Id }

  Result := DumStr;
End; { SetCheckKey }

//------------------------------

Function TTransMList.SetFilter : Str255;
Begin { SetFilter }
  Result:='';

  Case DayBkListMode of
    0..11   :  With Id do
               Begin

                 If (LineNo=RecieptCode) then
                   Result:='1'
                 else
                   Result:='0';

               end;

  End; {Case..}
End; { SetFilter }

//------------------------------

Function TTransMList.OutLine (Col : Byte) : Str255;
Var
  ExLocal : ^TdExLocal;
  GenStr  : ShortString;

  Function FormatBFloat(Fmask  :  Str255;
                        Value  :  Double;
                        SBlnk  :  Boolean)  :  Str255;
  Begin
    If (Value<>0.0) or (Not SBlnk) then
      Result:=FormatFloat(Fmask,Value)
    else
      Result:='';
  end;

  Function FormatBChar(C       :  Char;
                       SBlnk   :  Boolean)  :  Str5; Overload;
  Begin
    If (Ord(C)>32) and (Not SBlnk) then
      Result:=C
    else
      Result:='';
  end;

  Function FormatBChar(S       :  Str255;
                       SBlnk   :  Boolean)  :  Str5; Overload;
  Begin
    If (S<>'') and (Not SBlnk) then
      Result:=S
    else
      Result:='';
  end;

Begin { OutLine }
  ExLocal:=ListLocal;

  Result := '';

  With ExLocal^, Id do
  Begin
    If (EnterpriseLicence.elModuleVersion In [mvStock, mvSPOP]) Then
      // IFDEF STK
      If Is_FullStkCode(StockCode) And (LStock.StockCode <> StockCode) Then
      Begin
        //GetStock (Self, StockCode, FoundCode, -1);
        //AssignFromGlobal (StockF);
      End;
      // ENDIF

    Case DayBkListMode of
      0   : Case Col of
             0  :  OutLine:=StockCode;
             1  :  OutLine:=Item;
             2  :  OutLine:=FormatBFloat(GenQtyMask,Ea2Case(Id,LStock,Calc_IdQty(Qty,QtyMul,UsePack)),BOn);
             3  :  OutLine:=Desc;
             4  :  OutLine:=FormatBFloat(GenRealMask,InvLTotal(Id,Syss.ShowInvDisc,(LInv.DiscSetl*Ord(LInv.DiscTaken))),(Qty=0.0));
             5  :  Begin
                     If (VATIncFlg In VATSet) and (VATCode In VATEqStd) then
                       GenStr:=VATCode+VATIncFlg
                     else
                       GenStr:=VATCode;

                     OutLine:=FormatBChar(GenStr,(Qty=0.00));
                   end;
             6  :  OutLine:=FormatBFloat(GenUnitMask[IdDocHed In SalesSplit],NetValue,(Qty=0.0));
             7  :  {$IFDEF SOP}
                   begin //CS: 29/05/2009 Change to show Advanced Discounts
                     OutLine:= PPR_PamountStr(Discount,DiscountChr) + '/' +
                               PPR_PamountStr(Discount2,Discount2Chr) + '/' +
                               PPR_PamountStr(Discount3,Discount3Chr);
                     if Result = '//' then
                       Result := '';
                   end;
                   {$ELSE}
                   OutLine:=PPR_PamountStr(Discount,DiscountChr);
                   {$ENDIF}
             else
                   OutLine:='';
           End; {Case..}

      1  : Case Col of
             0   :  OutLine:=StockCode;
             1   :  OutLine:=MLocStk;
             2   :  OutLine:=POutDate(PDate);
             3   :  OutLine:=Form_BInt(NomCode,0);
             4,5 :  OutLine:=CCDep[(Col=4)];
             6   :  Begin
                      Rnum:=InvLTotal(Id,Syss.ShowInvDisc,(LInv.DiscSetl*Ord(LInv.DiscTaken)));
                      OutLine:=FormatBFloat(GenRealMask,Rnum,(Qty=0.0));
                    end;
             7   :  Begin
                      Rnum2:=InvLCost(Id);
                      OutLine:=FormatBFloat(GenRealMask,Rnum2,(Qty=0.0));
                    end;
             8   :  OutLine:=FormatBFloat(GenRealMask,Rnum-Rnum2,(Qty=0.0));
             9   :  OutLine:=FormatBFloat(GenPcntMask,Calc_Pcnt(Rnum,(Rnum-Rnum2)),(Qty=0.0));
           end; {Case..}

      2  : Case Col of
             0  :  OutLine:=dbFormatName(StockCode,Desc);
             1  :  OutLine:=FormatBFloat(GenQtyMask,Ea2Case(Id,LStock,Calc_IdQty(Qty,QtyMul,UsePack)),BOn);
             2  :  OutLine:=FormatBFloat(GenQtyMask,Ea2Case(Id,LStock,QtyDel),(Qty=0.0));
             3  :  OutLine:=FormatBFloat(GenQtyMask,Ea2Case(Id,LStock,QtyWOff),(Qty=0.0));
             4  :  OutLine:=FormatBFloat(GenQtyMask,Ea2Case(Id,LStock,Round_Up((Qty-(QtyDel+QtyWOff)),Syss.NoQtyDec)),(Qty=0.0));
             5  :  OutLine:=FormatBFloat(GenQtyMask,Ea2Case(Id,LStock,QtyPick),BOn);
             6  :  OutLine:=FormatBFloat(GenQtyMask,Ea2Case(Id,LStock,QtyPWOff),BOn);
           end; {Case..}

      3  : Case Col of
             0  :  OutLine:=StockCode;
             1  :  OutLine:=Desc;
             2  :  OutLine:=JobCode;
             3  :  OutLine:=AnalCode;
             4  :  OutLine:=FormatBFloat(GenRealMask,InvLTotal(Id,Syss.ShowInvDisc,(LInv.DiscSetl*Ord(LInv.DiscTaken))),(Qty=0.0));
           end; {Case..}
    End; {Case..}
  End; { With ExLocal^, Id }
End; { OutLine }

//=========================================================================

procedure TfrmSOPTrans.FormCreate(Sender: TObject);
Var
  n : Integer;
begin
  // Always display main tab first
  PageControl1.ActivePage := MainPage;

  // Create data interface object for list
  ExLocal.Create;

  // Initialise scroll-bar positions
  For N := 0 To Pred(ComponentCount) Do
    If (Components[n] is TScrollBox) Then
      With TScrollBox(Components[N]) Do Begin
        VertScrollBar.Position := 0;
        HorzScrollBar.Position := 0;
      End; { With TScrollBox(Components[n]) }
  VertScrollBar.Position:=0;
  HorzScrollBar.Position:=0;

  // Initialise Form Sizes
  InitSize.Y := 353;
  InitSize.X := 639;
  Self.ClientHeight := InitSize.Y;
  Self.ClientWidth  := InitSize.X;
  Constraints.MinHeight := InitSize.Y - 1;
  Constraints.MinWidth  := InitSize.X - 1;

  // MH 24/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
  // Save some co-ords for the dynamic re-shaping of the Settlement Discount section
  SavedSettleDiscPos[SetDiscOriginalFrameWidth] := SBSPanel55.Width;
  SavedSettleDiscPos[SetDiscOriginalFrameHeight] := SBSPanel55.Height;
  SavedSettleDiscPos[SetDiscOriginalFieldLeft] := I5Net1F.Left;
  SavedSettleDiscPos[SetDiscOriginalLabelWidth] := Label4.Width;

  // Setup misc internal variables
  LastCoord   := BOff;
  NeedCUpdate := BOff;
  ReCalcTot   := BOn;
  SetDefault  := BOff;
  StoreCoord  := BOff;

  // Setup VAT Matrix and decimals, etc...
  VATMatrix:=TVATMatrix.Create;
  FormDesign;

  // Initialise the Btrieve Lists
  FormBuildList (BOff);
end;

//------------------------------

procedure TfrmSOPTrans.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
Var
  n : SmallInt;
begin
  For n:=0 to Pred(ComponentCount) do
    If (Components[n] is TScrollBox) then
      With TScrollBox(Components[n]) do
      Begin
        VertScrollBar.Position:=0;
        HorzScrollBar.Position:=0;
      end;

  If (NeedCUpdate) then
    Store_FormCoord(Not SetDefault);
end;

//------------------------------

procedure TfrmSOPTrans.FormClose(Sender: TObject; var Action: TCloseAction);
Var
  n : SmallInt;
begin
  Action:=caFree;

  {* Note 0 is not destroyed, as this is the lists own copy *}

  With MULCtrlO do
  Begin
    VisiList:=MULVisiList[0];
  end;

  For n:=1 to High(MULVisiList) do
    If (MULVisiList[n]<>nil) then
      MULVisiList[n].Free;

  If (MULCtrlO<>nil) then
  Begin
    try
      MULCtrlO.Destroy;
    finally
      MULCtrlO:=nil;
    end;
  end;

  SendMessage ((Owner As TForm).Handle, WM_CustGetRec, 100, 1);
end;

//------------------------------

procedure TfrmSOPTrans.FormDestroy(Sender: TObject);
begin
  VATMatrix.Free;

  If Assigned(PayCtrl) Then
    FreeAndNIL(PayCtrl);

  If Assigned(IdLine) Then
    FreeAndNIL(IdLine);

  ExLocal.Destroy;
end;

//------------------------------

procedure TfrmSOPTrans.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;

//------------------------------

procedure TfrmSOPTrans.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

//------------------------------

procedure TfrmSOPTrans.FormResize(Sender: TObject);
Var
  n       : Byte;
  NewVal  : Integer;
begin
  If GotCoord {and (Not fDoingClose)} Then
  Begin
    //MULCtrlO.LinkOtherDisp:=BOff;

    Self.HorzScrollBar.Position:=0;
    Self.VertScrollBar.Position:=0;

    NewVal:=ClientWidth-PagePoint[0].X;
    (* HM Handled by Constraints
    If (NewVal<MinWidth) then
      NewVal:=MinWidth;
    *)
    PageControl1.Width:=NewVal;

    NewVal:=ClientHeight-PagePoint[0].Y;
    (* HM Handled by Constraints
    If (NewVal<MinHeight) then
      NewVal:=MinHeight;
    *)
    PageControl1.Height:=NewVal;


    I1SBox.Width:=PageControl1.Width-PagePoint[1].X;
    I1SBox.Height:=PageControl1.Height-PagePoint[1].Y;

    I1FPanel.Width:=PageControl1.Width- 10;

    I2SBox.Width:=I1SBox.Width;
    I2SBox.Height:=I1SBox.Height;
    I3SBox.Width:=I1SBox.Width;
    I3SBox.Height:=I1SBox.Height;

    I4SBox.Width:=I1SBox.Width;
    I4SBox.Height:=I1SBox.Height;

    RcSBox.Width:=I1SBox.Width;
    RcSBox.Height:=I1SBox.Height;


    I1BtnPanel.Left:=PageControl1.Width-PagePoint[2].X;
    I1BtnPanel.Height:=PageControl1.Height-PagePoint[2].Y;

    //I1BtnPanel2.Left:=I1BtnPanel.Left+1;

    I1BSBox.Height:=I1BtnPanel.Height-PagePoint[3].X;

    I1ListBtnPanel.Left:=PageControl1.Width-PagePoint[4].X;
    I1ListBtnPanel.Height:=PageControl1.Height-PagePoint[4].Y;

    RcListBtnPanel.Height:=I1ListBtnPanel.Height;

    //PayIPageResize;


    If (MULCtrlO<>nil) then
    Begin
      //LockWindowUpDate(Handle);

      For n:=High(MULVisiList) downto 0 do
        If (MULVisiList[n]<>nil) then
        Begin
          MULCtrlO.VisiList:=MULVisiList[n];

          With MULCtrlO,VisiList do
          Begin
            VisiRec:=List[0];

            With (VisiRec^.PanelObj as TSBSPanel) do
              Height:=I1SBox.ClientHeight-PagePoint[3].Y;

            RefreshAllCols;
          end;
        end; {Loop..}

      MULCtrlO.ReFresh_Buttons;

      If (Current_Page<4) then
      With MULCtrlO do
      Begin
        VisiList:=MULVisiList[Current_Page];
        RefreshAllCols;
      end;

      //LockWindowUpDate(0);
    end;{Loop..}

    //MULCtrlO.LinkOtherDisp:=BOn;

    NeedCUpdate:=((StartSize.X<>Width) or (StartSize.Y<>Height));
  end; {If time to update}
end;

//-------------------------------------------------------------------------

procedure TfrmSOPTrans.DisplayTrans (Const TheTrans : InvRec; Const TheCust : CustRec);

  // Run through Transaction Lines accumulating the VAT
  procedure ProcessLines;
  Var
    lStatus   : SmallInt;
    KeyS      : Str255;
    LineTotal : Double;
  Begin { ProcessLines }
    With ExLocal Do Begin
      // Zero out the VAT totals
      Blank(LInvNetTrig,Sizeof(LInvNetTrig));

      // Run through the Transaction lines
      KeyS := FullIdKey(LInv.FolioNum, 1);
      lStatus := Find_Rec (B_GetGEq, F[IDetailF], IDetailF, LRecPtr[IDetailF]^, IDFolioK, KeyS);
      While (LStatus = 0) And (LInv.FolioNum = LID.FolioRef) Do Begin
        If (Id.LineNo<>RecieptCode) then
          With LID Do Begin
            // Update VAT Flag
            LInvNetTrig[GetVAtNo(VATcode,VATIncFlg)]:=BOn; {* Show Rate is being used, Value independant *}

            // Update Goods Total
            LineTotal := Round_Up(InvLTotal(LId, BOn, (LInv.DiscSetl * Ord(LInv.DiscTaken))), 2);
            LInvNetAnal[GetVAtNo(VATcode,VATIncFlg)]:=LInvNetAnal[GetVAtNo(VATcode,VATIncFlg)]+LineTotal;
          End; { If (Id.LineNo<>RecieptCode) }

        // Get next line
        lStatus := Find_Rec (B_GetNext, F[IDetailF], IDetailF, LRecPtr[IDetailF]^, IDFolioK, KeyS);
      End; { While }
    End; { With ExLocal }
  End; { ProcessLines }

Begin { DisplayTrans }
  // Get static data from database
  ExLocal.LInv := TheTrans;
  ExLocal.LCust := TheCust;
  ProcessLines;

  // Update Form Caption
  Caption := Trim(EnterpriseData.edCompanyCode) + ', ' + ExLocal.LInv.OurRef;

  // Update form layout for licencing and document type
  BuildDesign;

  // Update user defined field captions and availability
  SetUDFields(ExLocal.LInv.InvDocHed);

  // MH 26/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
  ShowSettlementDiscountFields (TransactionHelper(@ExLocal.LInv).SettlementDiscountSupported);

  // Display Invoice
  SetInvFields;

  // Display Invoice Footer Totals
  OutInvTotals(Current_Page);

  If (Current_Page = 4) Then
    // Display VAT/Discount stuff
    RefreshFooter
  Else Begin
    ChangeList (Current_Page, BOff);
    ReFreshList (True, True);
  End;
End; { DisplayTrans }

//-------------------------------------------------------------------------

// CJS 2013-11-27 - MRD1.1.17 - Consumer Support
procedure TfrmSOPTrans.ResizeAcCodeField(ForConsumer: Boolean);
begin
  if Syss.ssConsumersEnabled and ForConsumer then
  begin
    lblAcCode.Left := 4;
    I1AccF.Left := 25;
    I1AccF.Width := 263;
    I1AddrF.Top := 33;
    I1AddrF.Height := 48;
  end
  else
  begin
    lblAcCode.Left := 184;
    I1AccF.Left := 208;
    I1AccF.Width := 80;
    I1AddrF.Top := 7;
    I1AddrF.Height := 74;
  end;
  // Force a re-positioning of the drop-down/pop-up arrows
  I1AccF.PosArrows;
end;

procedure TfrmSOPTrans.BuildDesign;
Var
  HideCC : Boolean;
begin
  With ExLocal, LInv, EnterpriseLicence Do
  Begin
    I1StatLab.Caption := 'STATUS:'#13'View Only';

    ResizeAcCodeField(InvDocHed in SalesSplit);

    // Set Version Specific Info
    If (elCurrencyVersion = cvPro) Then
    Begin
      // Single-Currency
      I1CurrLab.Visible:=BOff;
      I1CurrF.Visible:=BOff;
      I1ExRateF.Visible:=BOff;
      I1ExLab.Visible:=BOff;
      I5VRateL.Visible:=BOff;
      I5VRateF.Visible:=BOff;
      FixXRF.Visible:=BOff;
    End; { If (elCurrencyVersion = cvPro) }

    JobPage.TabVisible := (elModules[modJobCost] <> mrNone) Or JbFieldOn;

    I4JobCodeF.Visible:=JobPage.TabVisible;
    I4JobCodeL.Visible:=JobPage.TabVisible;

    I4JAnalL.Visible:=JobPage.TabVisible;
    I4JobAnalF.Visible:=JobPage.TabVisible;
    Bevel3.Visible:=JobPage.TabVisible;

    // IFDEF SOP
    If (elModuleVersion = mvSPOP) Then
    Begin
      // Override Location only available if enabled in System Setup and its a Purchase
      lblOverrideLocation.Visible := Syss.EnableOverrideLocations And (InvDocHed In PurchSplit);
      edtOverrideLocation.Visible := lblOverrideLocation.Visible;
      bevBelowOverrideLocation.Visible := lblOverrideLocation.Visible;
    End; // If (elModuleVersion = mvSPOP)

    PayPage.TabVisible:=(InvDocHed In DirectSet);

    If (InvDocHed In DirectSet) then
      PayPage.Caption:='Pay '+PayF2Tit[(InvDocHed In PayF2Set)];

    // Hide CostCentre/Department fields
    HideCC:=Not Syss.UseCCDep;

    I1CCLab.Visible:=Not HideCC;
    I1CCF.Visible:=Not HideCC;
    I1DepLab.Visible:=Not HideCC;
    I1DepF.Visible:=Not HideCC;

    I3CCLab.Visible:=Not HideCC;
    I3CCF.Visible:=Not HideCC;
    I3DepLab.Visible:=Not HideCC;
    I3DepF.Visible:=Not HideCC;

    I4CCLab.Visible:=Not HideCC;
    I4CCF.Visible:=Not HideCC;
    I4DepLab.Visible:=Not HideCC;
    I4DepF.Visible:=Not HideCC;

    If Not (elModuleVersion In [mvStock, mvSPOP]) Then
    Begin
      // $IFNDEF STK
      I2StkDescLab.Visible:=BOff;
      I2StkDescF.Visible:=BOff;
      I2QtyLab.Visible:=BOff;
      I2QtyF.Visible:=BOff;
      I3StkCodeLab.Visible:=BOff;
      I3StkCodeF.Visible:=BOff;
    End; { If Not (elModuleVersion In [mvStock, mvSPOP]) }

    If Not (elModuleVersion = mvSPOP) Then
    Begin
      // $IFNDEF SOP
      I1LocnLab.Visible:=BOff;
      I1LocnF.Visible:=BOff;
      I3LocnLab.Visible:=BOff;
      I3LocnF.Visible:=BOff;

      QtyPPage.TabVisible:=BOff;
      I1LocnLab.Visible:=BOff;
      I1LocnF.Visible:=BOff;
    End { If Not (elModuleVersion = mvSPOP) }
    Else Begin
      // SOP
      QtyPPage.TabVisible:=(InvDocHed In OrderSet);

      If (InvDocHed In PurchSplit) and (QtyPPage.TabVisible) then
      Begin
        QtyPPage.Caption:='Qty/Receive';
        I3QPKLab.Caption:='Received  ';
      End { If }
      else Begin
        QtyPPage.Caption:='Qty/Pick';
        I3QPKLab.Caption:='Picked   ';
      end;

      I1DueDateF.Visible:=(Not (InvDocHed In DeliverSet));
      I1DueDateL.Visible:=I1DueDateF.Visible;
    End; { Else }

    //Show_IntraStat(Syss.IntraStat or JBFieldOn,BOn);

    //ShuntExt;

    If (elCurrencyVersion <> cvPro) Then
    Begin
      // Euro/Global
      Set_DefaultCurr(I1CurrF.Items,BOff,BOff);
      Set_DefaultCurr(I1CurrF.ItemsL,BOff,BOn);

      FixXRF.Visible:=(InvDocHed In OrderSet) and (UseCoDayRate);
    End; { If (elCurrencyVersion <> cvPro) }

    I1YrRefF.MaxLength:=DocYRef1Len;

    I1YrRef2F.MaxLength:=DocYRef2Len;

    If (InvDocHed In OrderSet) then
    Begin
      I1DueDateL.Caption:='Del';
      I5NBL.Visible:=BOn;
      I5NBF.Visible:=BOn;
    End
    Else
    Begin
      I1DueDateL.Caption:='Due';

      I5NBL.Visible:=BOff;
      I5NBF.Visible:=BOff;
    end;

    If (InvDocHed In PurchSplit) then
      I2CostLab.Caption:='Uplift'
    else
      I2CostLab.Caption:='Cost';

    I1MargLab.Visible:=Show_CMG(InvDocHed);
    I1GPLab.Visible:=I1MargLab.Visible;
  End; { With ExLocal, LInv }

  // MH 19/05/2015 v7.0.14 ABSEXCH-16284: Hide PPD fields for non-qualifying transactions or if disabled on the account
  DisplayPPDFields;
End;

//-------------------------------------------------------------------------

procedure TfrmSOPTrans.SetUDFields(UDDocHed  :  DocTypes);
Var
  LabelArray: Array[1..10] of TLabel;
  FieldArray: Array[1..10] of TCustomEdit;
  UpperBound, LowerBound: Integer;
  PNo,n  :  Byte;
  Counter: Integer;
  UDAry,
  HDAry  :  Array[1..4] of Byte;
Begin
  PNo:=1;

  Case UDDocHed of
      SOR,SDN  :  Begin
                    For n:=1 to 4 do
                      UDAry[n]:=10+n;

                    HDAry:=UDAry;
                  end;
      POR,PDN  :  Begin
                    For n:=1 to 4 do
                      UDAry[n]:=34+n;

                    HDAry:=UDAry;
                  end;
      SQU      :  Begin
                    PNo:=2;
                    For n:=1 to 4 do
                      UDAry[n]:=24+n;

                    HDAry:=UDAry;
                  end;
      PQU      :  Begin
                    PNo:=2;

                    For n:=1 to 4 do
                      UDAry[n]:=32+n;

                    HDAry:=UDAry;
                  end;

      else        Begin
                    If (UDDocHed In SalesSplit) then
                    Begin
                      PNo:=0;
                      UDAry[1]:=3;
                      UDAry[2]:=4;
                      UDAry[3]:=13;
                      UDAry[4]:=14;

                      HDAry[1]:=0;
                      HDAry[2]:=5;
                      HDAry[3]:=6;
                      HDAry[4]:=7;

                    end
                    else
                    Begin
                      For n:=1 to 4 do
                        UDAry[n]:=18+n;

                      HDAry:=UDAry;
                    end;

                  end;
  end; {Case..}

  //GS 17/11/2011 ABSEXCH-12037: modifed UDF settings code to use the new "CustomFieldsIntF" unit
  LabelArray[1] := UDF1L;
  LabelArray[2] := UDF2L;
  LabelArray[3] := UDF3L;
  LabelArray[4] := UDF4L;
  LabelArray[5] := UDF5L;
  LabelArray[6] := UDF6L;
  LabelArray[7] := UDF7L;
  LabelArray[8] := UDF8L;
  LabelArray[9] := UDF9L;
  LabelArray[10] := UDF10L;

  FieldArray[1] := THUD1F;
  FieldArray[2] := THUD2F;
  FieldArray[3] := THUD3F;
  FieldArray[4] := THUD4F;
  FieldArray[5] := THUD5F;
  FieldArray[6] := THUD6F;
  FieldArray[7] := THUD7F;
  FieldArray[8] := THUD8F;
  FieldArray[9] := THUD9F;
  FieldArray[10] := THUD10F;

  EnableUDFs(LabelArray,
             FieldArray, DocTypeToCFCategory(ExLocal.LInv.InvDocHed, False), True);



  if lblOverrideLocation.Visible = False then
  begin
    //move the UDF controls to cover up the gap left behind by the over-ride field when it is hidden
    for Counter := Low(LabelArray) to High(LabelArray) do
    begin
      LabelArray[Counter].Top := LabelArray[Counter].Top - 40;
      FieldArray[Counter].Top := FieldArray[Counter].Top - 40;
    end;
    TransExtForm1.ExpandedHeight := TransExtForm1.ExpandedHeight - 40
  end;

  ResizeUDFParentContainer(NumberOfVisibleUDFs([THUD1F, THUD2F, THUD3F, THUD4F, THUD5F, THUD6F, THUD7F, THUD8F, THUD9F, THUD10F]),
                           2,
                           TransExtForm1);

end;

//-------------------------------------------------------------------------

procedure TfrmSOPTrans.FormDesign;
begin
  I2QtyF.DecPlaces:=Syss.NoQtyDec;

  // Moved as needs to be done every time a transaction is displayed
  //SetUDFields(ExLocal.LInv.InvDocHed);

  I1VATLab.Caption:=CCVATName^;
  I1VATTLab.Caption:=CCVATName^+I1VATTLab.Caption;
  I2VATTLab.Caption:=CCVATName^+I2VATTLab.Caption;
  I3VATTLab.Caption:=CCVATName^+I3VATTLab.Caption;
  I5MVATF.Caption:=CCVATName^+I5MVATF.Caption;
  I5VATRLab.Caption:=CCVATName^+I5VATRLab.Caption;
  I5VATLab.Caption:=CCVATName^;
  Label14.Caption:=CCVATName^;
  Label18.Caption:=CCVATName^;

  I5VRateL.Caption:=CCVATName^+I5VRateL.Caption;

  If CISOn then
    CISBackGroup1.Caption:=CCCISName^+' '+CISBackGroup1.Caption
  Else
    CISPanel1.Visible:=BOff;

  If (Syss.WarnYRef) then
    I1YrRefF.Charcase:=ecUpperCase;

  {* Build VAT Matrix *}
  try
    With VATMatrix do
    Begin
      AddVisiRec(I5VR1F,I5VV1F,I5VG1F);
      AddVisiRec(I5VR2F,I5VV2F,I5VG2F);
      AddVisiRec(I5VR3F,I5VV3F,I5VG3F);
      AddVisiRec(I5VR4F,I5VV4F,I5VG4F);
      AddVisiRec(I5VR5F,I5VV5F,I5VG5F);
      AddVisiRec(I5VR6F,I5VV6F,I5VG6F);
      AddVisiRec(I5VR7F,I5VV7F,I5VG7F);
      AddVisiRec(I5VR8F,I5VV8F,I5VG8F);
      AddVisiRec(I5VR9F,I5VV9F,I5VG9F);
      AddVisiRec(I5VR10F,I5VV10F,I5VG10F);
      AddVisiRec(I5VR11F,I5VV11F,I5VG11F);
      AddVisiRec(I5VR12F,I5VV12F,I5VG12F);
      AddVisiRec(I5VR13F,I5VV13F,I5VG13F);
      AddVisiRec(I5VR14F,I5VV14F,I5VG14F);
      AddVisiRec(I5VR15F,I5VV15F,I5VG15F);
      AddVisiRec(I5VR16F,I5VV16F,I5VG16F);
      AddVisiRec(I5VR17F,I5VV17F,I5VG17F);
      AddVisiRec(I5VR18F,I5VV18F,I5VG18F);
      AddVisiRec(I5VR19F,I5VV19F,I5VG19F);
      AddVisiRec(I5VR20F,I5VV20F,I5VG20F);
      AddVisiRec(I5VR21F,I5VV21F,I5VG21F);
    end;
  except
    VATMatrix:=nil
  end;
end;

//-------------------------------------------------------------------------

procedure TfrmSOPTrans.FormBuildList (ShowLines : Boolean);
Var
  StartPanel  :  TSBSPanel;
  n           :  Byte;
Begin
  If Not Assigned(MULCtrlO) Then
    MULCtrlO := TTransMList.Create(Self);

  Try
    With MULCtrlO do
    Begin
      Try
        With VisiList do
        Begin
          AddVisiRec (I1StkCodePanel,I1SCodeLab);
          AddVisiRec (I1ItemPanel,  I1ItemLab);
          AddVisiRec (I1QtyPanel,   I1QtyLab);
          AddVisiRec (I1DescPanel,  I1DescLab);
          AddVisiRec (I1LTotPanel,  I1LTotLab);
          AddVisiRec (I1VATPanel,   I1VATLab);
          AddVisiRec (I1UPricePanel,I1UPLab);
          AddVisiRec (I1DiscPanel,  I1DiscLab);
          AddVisiRec (I1DumPanel,   I1DumPanel);
          AddVisiRec (I1DumPanel,   I1DumPanel);

          VisiRec:=List[0];

          StartPanel:=(VisiRec^.PanelObj as TSBSPanel);

          HidePanels(0);

          LabHedPanel:=I1HedPanel;

          SetHedPanel(ListOfSet);
        end;
      except
        VisiList.Free;

      end;


      ListOfSet:=10;

      Find_FormCoord;

      TabOrder := -1;
      TabStop:=BOff;
      Visible:=BOff;
      BevelOuter := bvNone;
      ParentColor := False;
      Color:=StartPanel.Color;
      MUTotCols:=9;
      Font:=StartPanel.Font;

      LinkOtherDisp:=BOn;

      WM_ListGetRec:=WM_CustGetRec;


      Parent:=StartPanel.Parent;

      MessHandle:=Self.Handle;

      SetColDec(0);

      ListLocal:=@ExLocal;

      ListCreate;

      Filter[1,1]:='1'; {* Exclude Receipt part *}

      UseSet4End:=BOn;

      NoUpCaseCheck:=BOn;

      DayBkListMode:=0;

      Set_Buttons(I1ListBtnPanel);

      ReFreshList(ShowLines,BOff);

      MULVisiList[0]:=VisiList;

    end {With}


  Except

    MULCtrlO.Free;
    MULCtrlO:=Nil;
  end;

  FormSetOfSet;

  FormReSize(Self);
end;

//-------------------------------------------------------------------------

// Display Invoice Record
procedure TfrmSOPTrans.SetInvFields;
Var
  GenStr       :  Str255;
  n,m          :  Byte;
Begin { SetInvFields }
  With ExLocal, LInv, EnterpriseLicence Do
  Begin
    I1OurRefF.Text:=Pr_OurRef(LInv);
    I1OpoF.Text:=OpName;

    { CJS - 2013-10-25 - MRD2.6.05 - Transaction Originator }
    if (Trim(thOriginator) <> '') then
      I1OpoF.Hint := GetOriginatorHint(LInv)
    else
      I1OpoF.Hint := '';
      
    I1AccF.Text:=Strip('R',[#32],CustCode);

    I1PrYrF.InitPeriod(AcPr,AcYr,BOn,BOn);

    I1TransDateF.DateValue:=TransDate;
    I1DueDateF.DateValue:=DueDate;

    I1YrRefF.Text:=Trim(YourRef);
    I1YrRef2F.Text:=Trim(TransDesc);

    DMDCNomF.Text:=Form_BInt(CtrlNom,0);

    If (elCurrencyVersion In [cvEuro, cvGlobal]) Then
    Begin
      // $IFDEF MC_On
      If (Currency>0) then
        I1CurrF.ItemIndex:=Pred(Currency);

      I1ExRateF.Value:=CXRate[BOn];

      I5VRateF.Value:=VatCRate[BOn];
    End; { If }

    CustToMemo(LCust,I1AddrF,0);

    If (Not EmptyAddr(DAddr)) then
      LCust.DAddr:=DAddr
    else
      If (EmptyAddr(LCust.DAddr)) then
        LCust.DAddr:=LCust.Addr;

    If (elModules[modJobCost] <> mrNone) Or JbFieldOn Then
    Begin
      // (JbCostOn) or (JbFieldOn)
      I4JobCodeF.Text:=DJobCode;
      I4JobAnalF.Text:=DJobAnal;
    end;

    If edtOverrideLocation.Visible Then
      edtOverrideLocation.Text := thOverrideLocation;

    If (Syss.IntraStat) or JbFieldOn then
    Begin
      ISDelF.Text:=Trim(DelTerms);
      ISTTF.Value:=TransNat;
      ISMTF.Value:=TransMode;
      ISPTF.ItemIndex:=PTtoCB(SSDProcess);
    end;

    I5NBF.Value:=NoLabels;

    THUD1F.Text:=DocUser1;
    THUD2F.Text:=DocUser2;
    THUD3F.Text:=DocUser3;
    THUD4F.Text:=DocUser4;
    //GS 17/11/2011 ABSEXCH-12037: put customisation values into text boxes
    THUd5F.Text:=DocUser5;
    THUd6F.Text:=DocUser6;
    THUd7F.Text:=DocUser7;
    THUd8F.Text:=DocUser8;
    THUd9F.Text:=DocUser9;
    THUd10F.Text:=DocUser10;

    I5MVATF.Checked:=ManVAT;

    FixXRF.Checked:=SOPKeepRate;

    // Settlement Discount
    I5SDPF.Value:=Pcnt2Full(DiscSetl);
    I5SDDF.Value:=DiscDays;
    I5SDTF.Checked:=(DiscTaken or (PDiscTaken and (Not InAddEdit)));

    // MH 20/03/2015 v7.0.14 ABSEXCH-16284: Added Prompt Payment Discount fields
    ccyPPDPercentage.Value := Pcnt2Full(thPPDPercentage);
    ccyPPDDays.Value := thPPDDays;

    // MH 05/05/2015 v7.0.14 ABSEXCH-16284: Set PPD status label here
    UpdatePPDStatusInfo;

    // MH 24/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
    ShowSettlementDiscountFields (TransactionHelper(@LInv).SettlementDiscountSupported);

    If (Currency<>Syss.VATCurr) and (Not (Syss.VATCurr In [0,1])) then
    Begin
      If (Not I5VRateL.Visible) then
      Begin
        I5VRateL.Visible:=BOn;
        I5VRateF.Visible:=BOn;

        ScrollBox8.Height:=ScrollBox8.Height-24;
        ScrollBox8.Top:=ScrollBox8.Top+24;
        SBSPanel54.Top:=SBSPanel54.Top+24;
      end;
    End
    Else Begin
      If (I5VRateL.Visible) then
      Begin
        I5VRateL.Visible:=BOff;
        I5VRateF.Visible:=BOff;

        ScrollBox8.Height:=ScrollBox8.Height+24;
        ScrollBox8.Top:=ScrollBox8.Top-24;
        SBSPanel54.Top:=SBSPanel54.Top-24;
      End;
    End; { Else }
  End; { With ExLocal, LInv, EnterpriseLicence }
End; { SetInvFields }

//-------------------------------------------------------------------------

Procedure TfrmSOPTrans.OutInvTotals (Const NewIndex : Integer);
Begin { OutInvTotals }
  With ExLocal, LInv Do
  Begin
    If (EnterpriseLicence.elCurrencyVersion In [cvEuro, cvGlobal]) Then
      // $IFDEF MC_On
      CurrLab1.Caption:=SSymb(Currency);

    Case NewIndex Of
      1  :  Begin
              INetTotF.Value:=ITotal(LInv)-InvVAT;

              IVATTotF.Value:=INetTotF.Value-TotalCost;

              IGTotF.Value:=Calc_Pcnt(INetTotF.Value,IVATTotF.Value);
            end;
      5  :  Begin
              INetTotF.Value:=ConvCurrITotal(LInv,BOff,BOff,BOn);

              IVATTotF.Value:=TotalInvoiced;

              IGTotF.Value:=INetTotF.Value-TotalInvoiced;

            end;

      else
            Begin
              IGTotF.Value:=ITotal(LInv);
              IVATTotF.Value:=InvVAT;

              If (Syss.ShowInvDisc) then
                INetTotF.Value:=IGTotF.Value-InvVat
              else
                INetTotF.Value:=InvNetVal;

            end;
    End; { Case NewIndex }
  End; { With ExLocal, LInv }
End; { OutInvTotals }

//-------------------------------------------------------------------------

// Display Invoice Footer Totals
Procedure TfrmSOPTrans.OutInvFooterTot;
Var
  n       :  VATType;
  DiscT   :  Boolean;
  Tot1, Tot2, Tot3 : Double;
  lvTransTot : TListView;
Begin
  With ExLocal,LInv do
  Begin
    If (VATMatrix<>nil) then
      With VATMatrix do
      Begin
        For n:=VStart to VEnd do
        Begin
          IdRec(Ord(n))^.GoodsD.Value:=LInvNetAnal[n];
          IdRec(Ord(n))^.VATD.Value:=InvVATAnal[n];
        end;
      end;

    {* Show remaining total fields *}

    DiscT:=DiscTaken;

    I5Net1F.Value:=InvNetVal;
    I5Net2F.Value:=InvNetVal;

    I5VAT1F.Value:=InvVAT;
    I5VAT2F.Value:=InvVAT;

    I5Disc1F.Value:=DiscAmount;

    If (JBFieldOn) then
      I5Disc2F.Value:=DiscSetAm
    else
      I5Disc2F.Value:=DiscAmount+DiscSetAm;

    DiscTaken:=BOff;
    I5Tot1F.Value:=ITotal(LInv);

    DiscTaken:=BOn;

    I5Tot2F.Value:=ITotal(LInv);

    // MH 27/05/2015 v7.0.14: Added the No-PPD Page to allow for a different listview layout
    //                        without having to do it all at runtime
    If (nbSettleDisc.PageIndex = NoPromptPaymentDiscountPage) Then
      lvTransTot := lvTransactionTotals
    Else
      lvTransTot := lvTransactionTotalsPPD;

    // MH 20/03/2015 v7.0.14 ABSEXCH-16284: Added Prompt Payment Discount fields
    lvTransTot.Clear;
    With lvTransTot.Items.Add Do
    Begin
      Caption := 'Net';

      Tot1 := Round_Up(InvNetVal - DiscAmount, 2);
      SubItems.Add(FormatFloat(GenRealMask, Tot1));

      // MH 19/05/2015 v7.0.14 ABSEXCH-16284: Hide PPD fields for non-qualifying transactions or if disabled on the account
      If (lvTransTot = lvTransactionTotalsPPD) Then
      Begin
        Tot2 := Round_Up(thPPDGoodsValue, 2);
        SubItems.Add(FormatFloat(GenRealMask, Tot2));

        Tot3 := Round_Up(Tot1 - thPPDGoodsValue, 2);
        SubItems.Add(FormatFloat(GenRealMask, Tot3));
      End; // If (lvTransTot = lvTransactionTotalsPPD)
    End; // With lvTransTot.Items.Add
    With lvTransTot.Items.Add Do
    Begin
      Caption := CCVATName^;

      Tot1 := Round_Up(Tot1 + InvVAT, 2);
      SubItems.Add(FormatFloat(GenRealMask, InvVAT));

      // MH 19/05/2015 v7.0.14 ABSEXCH-16284: Hide PPD fields for non-qualifying transactions or if disabled on the account
      If (lvTransTot = lvTransactionTotalsPPD) Then
      Begin
        Tot2 := Round_Up(Tot2 + thPPDVATValue, 2);
        SubItems.Add(FormatFloat(GenRealMask, thPPDVATValue));

        Tot3 := Round_Up(Tot3 + (InvVAT - thPPDVATValue), 2);
        SubItems.Add(FormatFloat(GenRealMask, Round_Up(InvVAT - thPPDVATValue, 2)));
      End; // If (lvTransTot = lvTransactionTotalsPPD)
    End; // With lvTransTot.Items.Add
    With lvTransTot.Items.Add Do
    Begin
      Caption := 'Total';
      SubItems.Add(FormatFloat(GenRealMask, Tot1));

      // MH 19/05/2015 v7.0.14 ABSEXCH-16284: Hide PPD fields for non-qualifying transactions or if disabled on the account
      If (lvTransTot = lvTransactionTotalsPPD) Then
      Begin
        SubItems.Add(FormatFloat(GenRealMask, Tot2));
        SubItems.Add(FormatFloat(GenRealMask, Tot3));
      End; // If (lvTransTot = lvTransactionTotalsPPD)
    End; // With lvTransTot.Items.Add

    // MH 19/05/2015 v7.0.14 ABSEXCH-16284: Hide PPD fields for non-qualifying transactions or if disabled on the account
    UpdatePPDStatusInfo;

    // MH 20/03/2015 v7.0.14 ABSEXCH-16284: Update Look and feel of Line Type Totals
    lvLineTypeTotals.Clear;
    With lvLineTypeTotals.Items.Add Do
    Begin
      Caption := 'Type: ' + Trim(CustomFields[cfLinetypes, 1].cfCaption);
      SubItems.Add(FormatFloat(GenRealMask, DocLSplit[1]));
    End; // With lvLineTypeTotals.Items.Add
    With lvLineTypeTotals.Items.Add Do
    Begin
      Caption := 'Type: ' + Trim(CustomFields[cfLinetypes, 2].cfCaption);
      SubItems.Add(FormatFloat(GenRealMask, DocLSplit[2]));
    End; // With lvLineTypeTotals.Items.Add
    With lvLineTypeTotals.Items.Add Do
    Begin
      Caption := 'Type: ' + Trim(CustomFields[cfLinetypes, 3].cfCaption);
      SubItems.Add(FormatFloat(GenRealMask, DocLSplit[3]));
    End; // With lvLineTypeTotals.Items.Add
    With lvLineTypeTotals.Items.Add Do
    Begin
      Caption := 'Type: ' + Trim(CustomFields[cfLinetypes, 4].cfCaption);
      SubItems.Add(FormatFloat(GenRealMask, DocLSplit[4]));
    End; // With lvLineTypeTotals.Items.Add
    With lvLineTypeTotals.Items.Add Do
    Begin
      Caption := 'Line Discount';
      SubItems.Add(FormatFloat(GenRealMask, DiscAmount));
    End; // With lvLineTypeTotals.Items.Add

    DiscTaken:=DiscT;

    If (CISOn) then
    Begin
      If (CISEmpl<>'') then
      Begin
        I5CISTaxF.Value:=CISTax;
        I5CISDecF.Value:=CISDeclared*DocCnst[InvDocHed]*DocNotCnst;

        I5CISGrossF.Value:=CISGross;
        I5CISManCb.Checked:=CISManualTax;
        I5CISPeriodF.DateValue:=CISDate;
            
        If (I5VRateF.Visible) then
          ScrollBox8.Height:=121
        else
          ScrollBox8.Height:=145;



        CISPanel1.Visible:=BOn;

        If (Round_Up(CISGross+CISTax,2)=0.0) then {Its a non taxable calc}
        Begin

          I5CISGrossF.Value:=ITotal(LInv);

          Label1.Caption:=CCCISName^+' Gross';

          If (CurrentCountry<>IECCode) then
            I5CISGrossF.Value:=I5CISGrossF.Value-InvVAT;

          I5CISManCb.Visible:=BOff;
          I5CISTaxF.Visible:=BOff;
          I5CISDecF.Left:=I5CISTaxF.Left;
          Label2.Caption:='Declared';
        end;
      end
      else
      Begin
        ScrollBox8.Height:=244;
        CISPanel1.Visible:=BOff;
      end;
    end;
  end;
end;

//-------------------------------------------------------------------------

// Display Invoice Total
Procedure TfrmSOPTrans.SetInvTotPanels (Const NewIndex : Integer);
Var
  NewParent  :  TWinControl;
Begin
  INetTotF.Visible:=(NewIndex In [0..3,5]);

  IVatTotF.Visible:=((INetTotF.Visible) and ((NewIndex<>1) or (I1MargLab.Visible)));

  IGTotF.Visible:=(IVATTotF.Visible);

  Case NewIndex of
    1  :  With IGTotF do
          Begin
            DecPlaces:=1;
            DisplayFormat:=GenPcntMask;
          end;

    else  With IGTotF do
          Begin
            DisplayFormat:=GenRealMask;
            DecPlaces:=2;
          end;
  end; {Case..}

  If (NewIndex In [0..3,5]) then
  Begin
    Case NewIndex of
      1  :  NewParent:=I2BtmPanel;
      2  :  NewParent:=I3BtmPanel;
      3  :  NewParent:=I4BtmPanel;
      5  :  NewParent:=I6BtmPanel;
      else  NewParent:=I1BtmPanel;
    end; {Case..}

    INetTotF.Parent:=NewParent;
    IVatTotF.Parent:=NewParent;
    IGTotF.Parent:=NewParent;
  end;
end;

//-------------------------------------------------------------------------

procedure TfrmSOPTrans.ReFreshFooter;
Begin
  With ExLocal, LInv Do
  Begin
    // HM: Not Required by DrillDown
    //If (ForceStore) or (LastEdit) or (LViewOnly) then
    //  CalcInvTotals(LInv,ExLocal,Not ManVAT,BOn);

    VATMatrix.HideVATMatrix(LInvNetTrig);

    OutInvFooterTot;
  End; { With ExLocal, LInv }
end;

//-------------------------------------------------------------------------

Function TfrmSOPTrans.Current_Page : Integer;
Begin
  Result := pcLivePage (PageControl1);
end;

//-------------------------------------------------------------------------

procedure TfrmSOPTrans.PageControl1Change(Sender: TObject);
Var
  NewIndex  : Integer;
  //NoteSetUp :  TNotePadSetUp;
  PaySetUp  : TPayInSetUp;
begin
  If (Sender is TPageControl) Then
    With Sender as TPageControl do
    Begin
      NewIndex:=pcLivePage(Sender);

      {$B-}

        If (NewIndex=4) or ((NewIndex In [0..3]) and (MULVisiList[NewIndex]<>nil)) then
          LockWindowUpDate(0);

      {$B+}

      //PrimeButtons;

      If (Not TransExtForm1.NewSetting) and (NewIndex>3) then {* Panel is open, so close it *}
        TransExtForm1.ForceClose;

      If (NewIndex=4) or (Not I1BtnPanel.Visible) then
      Begin

        I1BtnPanel.Visible:=(NewIndex<>4);
        I1BtnPanel.Enabled:=(NewIndex<>4);

        {I1BtnPanel2.Visible:=(NewIndex<>4);
        I1BtnPanel2.Enabled:=(NewIndex<>4);}

        I1FPanel.Visible:=(NewIndex<>4);
      end;

      If (NewIndex=0) then
      Begin
        //I1AddrF.Color:=I1AccF.Color;
        //I1AddrF.Font.Color:=I1AccF.Font.Color;

        CustToMemo(ExLocal.LCust,I1AddrF,0);
      end
      else
      With ExLocal,LInv do
      Begin
        //I1AddrF.Color:=clBtnFace;
        //I1AddrF.Font.Color:=clBlack;

        If (Not EmptyAddr(DAddr)) then
          LCust.DAddr:=DAddr
        else
          If (EmptyAddr(LCust.DAddr)) then
            LCust.DAddr:=LCust.Addr;

        CustToMemo(LCust,I1AddrF,0);

      end;

      SetInvTotPanels(NewIndex);
      OutInvTotals(NewIndex);

      Case NewIndex of
        0..3  : ChangeList(NewIndex,BOn);

        4     : If (ReCalcTot) then
                Begin
                  ReCalcTot:=BOff;
                  ReFreshFooter;
                end;

        5  :  Begin
                If Not Assigned(PayCtrl) Then
                  With ExLocal Do
                  Begin
                    PayCtrl:=TPayLine.Create(Self);

                    With PaySetUp do
                    Begin
                      ColPanels[0]:=RCNPanel; ColPanels[1]:=RCNLab;
                      ColPanels[2]:=RCDPanel; ColPanels[3]:=RCDLab;
                      ColPanels[4]:=RCQPanel; ColPanels[5]:=RCQLab;

                      ColPanels[6]:=RCPPanel; ColPanels[7]:=RCPLab;
                      ColPanels[8]:=RCBPanel; ColPanels[9]:=RcBLab;
                      ColPanels[10]:=RCRPanel; ColPanels[11]:=RCRLab;

                      ColPanels[12]:=RcHedPanel;
                      ColPanels[13]:=RcListBtnPanel;

                      ScrollBox:=RcSBox;
                      PropPopUp:=StoreCoordFlg;

                      CoorPrime:=LowerCase(DocCodes[LInv.InvDocHed])[1];
                      CoorHasCoor:=LastCoord;

                    end;

                    try
                      PayCtrl.CreateList(Self,PaySetUp,BOn,LInv);


                    except
                      PayCtrl.Free;
                      PayCtrl:=Nil
                    end;

                  End { With ExLocal }
                else
                  With ExLocal do
                  Begin
                    If (LInv.FolioNum<>PayCtrl.GetFolio) then {* Refresh notes *}
                      with PayCtrl do
                      Begin
                        RefreshList(LInv.FolioNum);
                      end;

                    PayCtrl.ExLocal.LInv:=LInv;
                  End; { With ExLocal }
              end;

      end; {Case..}
    end;

  LockWindowUpDate(0);
end;

//-------------------------------------------------------------------------

procedure TfrmSOPTrans.PageControl1Changing(Sender: TObject; var AllowChange: Boolean);
begin
  Release_PageHandle(Sender);
  LockWindowUpDate(Handle);
end;

//-------------------------------------------------------------------------

// IMPORTANT NOTE: This message handler is required to ensure the form stays
// on top, as it has a habit of losing its Stay-On-Top'ness at runtime.
procedure TfrmSOPTrans.WMWindowPosChanged(var Msg : TMessage);
Var
  TopWindow : TWinControl;
Begin
  // Do standard message processing
  Inherited;

  // HM 22/10/03: Added Visible check as it hangs under win 98 otherwise
  If Self.Visible Then
  Begin
    // Check to see if the TopMost window is a Drill-Down window
    TopWindow := FindControl(PWindowPos(Msg.LParam).hwndInsertAfter);
    If Not Assigned(TopWindow) Then
      // Restore TopMost back to window
      SetWindowPos(Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE or SWP_NOACTIVATE);
  End; // If Self.Visible
End;

//-------------------------------------------------------------------------

Function TfrmSOPTrans.Current_BarPos (Const PageNo : Byte) : Integer;
Begin
  Case PageNo of
    0  :  Result:=I1SBox.HorzScrollBar.Position;
    1  :  Result:=I2SBox.HorzScrollBar.Position;
    2  :  Result:=I3SBox.HorzScrollBar.Position;
    3  :  Result:=I4SBox.HorzScrollBar.Position;
  else
    Result:=0;
  end; {Case..}
end;

//------------------------------

Procedure TfrmSOPTrans.SetCurrent_BarPos(Const PageNo : Byte; Const NewBO : Integer);
Begin
  Case PageNo of
    0  :  I1SBox.HorzScrollBar.Position:=NewBO;
    1  :  I2SBox.HorzScrollBar.Position:=NewBO;
    2  :  I3SBox.HorzScrollBar.Position:=NewBO;
    3  :  I4SBox.HorzScrollBar.Position:=NewBO;
  End; {Case..}
End;

//-------------------------------------------------------------------------

Procedure TfrmSOPTrans.SetColDec (PageNo : Byte);
Var
  n  :  Byte;
Begin
  With MULCtrlO do
  Begin
    For n:=0 to MUTotCols do
      With ColAppear^[n], ExLocal.LInv do
      Begin
        AltDefault:=BOn;

        DispFormat:=SGText;

        If ((n In [4,6]) and (PageNo In [0,3]))
          or ((n=2) and (PageNo=0))
          or ((n In [3,6,7,8,9]) and (PageNo=1))
          or ((n In [1..6]) and (PageNo=2))
          or ((n=4) and (PageNo=3)) then
        Begin
          DispFormat:=SGFloat;
          NoDecPlaces:=2;

          If (n=6) and (PageNo In [0,3]) then
          Begin
            If (InvDocHed In SalesSplit) then
              NoDecPlaces:=Syss.NoNetDec
            else
              NoDecPlaces:=Syss.NoCosDec;
          end
          else
            If (n=3) and (PageNo=1) then
              NoDecPlaces:=0
            else
              If ((n In [1..6]) and (PageNo=2))
                or ((n=2) and (PageNo=0)) then
                NoDecPlaces:=Syss.NoQtyDec;
        end;
      end;
  end; {With..}
end; {Proc..}

//-------------------------------------------------------------------------

procedure TfrmSOPTrans.HidePanels (PageNo : Byte);
Var
  TmpBo, LocBo, DelBo, CCDepBo : Boolean;
  n                            : Integer;
Begin
  With MULCtrlO, VisiList, ExLocal.LInv do
  Begin
    fBarOfSet:=Current_BarPos(PageNo);
    vUseOfSet:=BOn;

    Case PageNo of

      0
         :  Begin
              If (EnterpriseLicence.elModuleVersion In [mvStock, mvSPOP]) Then
                // IFDEF STK
                TmpBo:=BOn
              Else
                TmpBo:=BOff;
              //RJ 08/02/2016 2016-R1 ABSEXCH-14990: Hiding Panel depend upon the Panel object , Overloaded Method instead of Default Index
              SetHidePanel(I1StkCodePanel,Not TmpBo,BOff);
              SetHidePanel(I1ItemPanel,TmpBo,BOn);
              SetHidePanel(8,BOn,BOff);
              SetHidePanel(9,BOn,BOn);
            end;

      1  :  Begin
              LocBo:=BOff; CCDepBo:=BOff;

              If (EnterpriseLicence.elModuleVersion <> mvSPOP) Then
                // IFNDEF SOP
                LocBo:=BOn;

              CCDepBo:=Not Syss.UseCCDep;

              DelBo:=(Not (InvDocHed In PSOPSet));

              TmpBo:=(Not Show_CMG(InvDocHed));

              SetHidePanel(0,Not MULVisiList[0].IdPanel(0,BOff).Visible,BOff);

              SetHidePanel(1,LocBo,BOff);
              SetHidePanel(2,DelBo,BOff);

              SetHidePanel(4,CCDepBo,BOff);
              SetHidePanel(5,CCDepBo,BOff);

              SetHidePanel(7,TmpBo and (Not (InvDocHed In PurchSplit)),BOff);
              SetHidePanel(8,TmpBo,BOff);
              SetHidePanel(9,TmpBo,BOn);

            end;
      2..3
         :  Begin
              For n:=0 to MUTotCols do
                SetHidePanel(n,((n>6) and (PageNo=2))
                            or ((n>4) and (PageNo=3))
                            or ((n=0) and (PageNo=3) and (Not MULVisiList[0].IdPanel(0,BOff).Visible)),

                            ((n=9) and (PageNo<>1)));
            end;
    end; {Case..}

  end;
end;

//-------------------------------------------------------------------------

Procedure TfrmSOPTrans.InitVisiList (PageNo : Byte);
Var
  Idx  :  Integer;
Begin
  If (MULVisiList[PageNo]=nil) then
  Begin
    MULVisiList[PageNo]:=TVisiList.Create;

    try
      With MULVisiList[PageNo] do
        Case PageNo of
          1  :  Begin
                  AddVisiRec(I2StkCodePanel,I2SCodeLab);
                  AddVisiRec(I2LocnPanel,I2LocnLab);
                  AddVisiRec(I2DelDatePanel,I2DelLab);
                  AddVisiRec(I2NomPanel,I2NomLab);
                  AddVisiRec(I2CCPanel,I2CCLab);
                  AddVisiRec(I2DepPanel,I2DepLab);
                  AddVisiRec(I2NetValPanel,I2NValLab);
                  AddVisiRec(I2CostPanel,I2CostLab);
                  AddVisiRec(I2MargPanel,I2MargLab);
                  AddVisiRec(I2GPPanel,I2GPLab);

                  LabHedPanel:=I2HedPanel;
                end;

          2  :  Begin
                  AddVisiRec(I3StkDPAnel,I3StkDLab);
                  AddVisiRec(I3QOrdPanel,I3QOrdLab);
                  AddVisiRec(I3QDelPanel,I3DelLab);
                  AddVisiRec(I3QWOPanel,I3QWOLab);
                  AddVisiRec(I3QOSPanel,I3QOSLab);
                  AddVisiRec(I3QPkPanel,I3QPkLab);
                  AddVisiRec(I3QTWPanel,I3QTWLab);
                  AddVisiRec(I1DumPanel,I1DumPanel);
                  AddVisiRec(I1DumPanel,I1DumPanel);
                  AddVisiRec(I1DumPanel,I1DumPanel);

                  LabHedPanel:=I3HedPanel;
                end;

          3  :  Begin
                  AddVisiRec(I4StkCPanel,I4StkCLab);
                  AddVisiRec(I4StkDPanel,I4StkDLab);
                  AddVisiRec(I4JCPanel,I4JCLab);
                  AddVisiRec(I4JAPanel,I4JALab);
                  AddVisiRec(I4LTotPanel,I4LTotLab);
                  AddVisiRec(I1DumPanel,I1DumPanel);
                  AddVisiRec(I1DumPanel,I1DumPanel);
                  AddVisiRec(I1DumPanel,I1DumPanel);
                  AddVisiRec(I1DumPanel,I1DumPanel);
                  AddVisiRec(I1DumPanel,I1DumPanel);

                  LabHedPanel:=I4HedPanel;
                end;
        end; {Case..}

      With MULCtrlO do
        VisiList:=MULVisiList[PageNo];

      With MULCtrlO do
        Match_VisiList(MULVisiList[0],VisiList);
    except
      MULVisiList[PageNo].Free;
      MULVisiList[PageNo]:=nil;
    end; {try..}
  end; {already initialised}
end; {Proc..}

//-------------------------------------------------------------------------

procedure TfrmSOPTrans.RefreshList (ShowLines, IgMsg : Boolean);
Var
  KeyStart : Str255;
Begin
  KeyStart:=FullIdkey(EXLocal.LInv.FolioNum, 1);

  With MULCtrlO do
  Begin
    IgnoreMsg:=IgMsg;

    StartList(IdetailF,IdFolioK,KeyStart,'','',4,(Not ShowLines));

    IgnoreMsg:=BOff;
  end;
end;

//-------------------------------------------------------------------------

Procedure TfrmSOPTrans.ChangeList (PageNo : Byte; ShowLines : Boolean);
Var
  NewBar  :  Integer;
Begin
  NewBar:=0;

  If (PageNo<4) then
    With MULCtrlO do
    Begin
      SetCurrent_BarPos(PageNo,0);

      If (MULVisiList[PageNo]=nil) then
        InitVisiList(PageNo)
      else
      Begin
        VisiList:=MULVisiList[PageNo];
      end;

      I1ListBtnPanel.Parent:=PageControl1.Pages[PageNo];

      DayBkListMode:=PageNo;

      SetColDec(PageNo);

      HidePanels(PageNo);

      ReAssignCols;

      If (ShowLines) then
      Begin
        PageUpDn(0,BOn);

        VisiList.SetHedPanel(ListOfSet+NewBar);
      end;
    end; {With..}
End;

//-------------------------------------------------------------------------

Procedure TfrmSOPTrans.Link2Nom;
Var
  KeyS    : Str255;
  lStatus : SmallInt;
Begin
  With ExLocal, Id do
  Begin
    If (LNom.NomCode <> NomCode) then
    Begin
      //GetNom(Self,Form_Int(NomCode,0),FoundCode,-1);
      KeyS := FullNomKey (NomCode);
      Find_Rec (B_GetEq, F[NomF], NomF, LRecPtr[NomF]^, NomCodeK, KeyS);
    End; { If (LNom.NomCode <> NomCode) }

    I1NomCodeF.Text:=LNom.Desc;
    I4NomF.Text:=I1NomCodeF.Text;

    I1CCF.Text:=CCDep[BOn];
    I1DepF.Text:=CCDep[BOff];
    I4CCF.Text:=CCDep[BOn];
    I4DepF.Text:=CCDep[BOff];
    I3CCF.Text:=CCDep[BOn];
    I3DepF.Text:=CCDep[BOff];

    I1LocnF.Text:=MLocStk;
    I3LocnF.Text:=MLocStk;

    I2StkDescF.Text:=Desc;
    I2QtyF.Value:=Calc_IdQty(Qty,QtyMul,UsePack);

    I3StkCodeF.Text:=Id.StockCode;

    (*** HM ???
    {$IFDEF STK} {* Link up for List auto search to work *}
      With ExLocal do
      If (Is_FullStkCode(StockCode)) and (LStock.StockCode<>StockCode) then
      Begin
        GetStock(Self,StockCode,FoundStk,-1);
        AssignFromGlobal(StockF);
      end;
    {$ENDIF}
    ***)
  end; {With..}
end; {Proc..}

//-------------------------------------------------------------------------

Procedure TfrmSOPTrans.WMCustGetRec(Var Message  :  TMessage);
Var
  mbRet  :  Word;
Begin
  With Message do
  Begin
    Case WParam of
      { 0 = dbl click on line, 169 = pressed drill down button}
      0,169
         :  Begin
              If (WParam=169) then
                MULCtrlO.GetSelRec(BOff);

              Case Current_Page of

                5  : btnViewLineClick(btnViewLine);

              else
                Display_Id(Id, False);
              end; {Case..}
            end;

      { 1 = Selected line changed }
      1  :  Begin
              {* Show nominal/cc dep data *}
              Link2Nom;

              Display_Id(Id, True);

              (*
              If (IdLine<>nil) and (IdLineActive) then
              With IdLine do
              Begin
                If (WindowState<>wsMinimized) and (Not ExLocal.InAddEdit)
                and (Id.ABSLineNo<>ExLocal.LId.ABSLineNo) then
                Begin
                  Display_Id(0);
                end;
              end;

              With Id do
                SendToObjectStkEnq(StockCode,MLocStk,CustCode,Currency,-1,0);
              *)
            end;

     //2  :  ShowRightMeny(LParamLo,LParamHi,1);

     25  :  NeedCUpdate:=BOn;

     100 : Case LParam Of
             1  : IdLine := NIL;
           End; { Case }
    end; {Case..}

  end;
  Inherited;
end;

//-------------------------------------------------------------------------

procedure TfrmSOPTrans.Store_FormCoord (UpMode : Boolean);
Var
  GlobComp:  TGlobCompRec;
Begin { Store_FormCoord }
  New(GlobComp,Create(BOff));

  With GlobComp^ do
  Begin
    GetValues:=UpMode;

    PrimeKey:=LowerCase(DocCodes[ExLocal.LInv.InvDocHed])[1];

    ColOrd:=Ord(StoreCoord);

    HLite:=Ord(LastCoord);

    SaveCoord:=StoreCoord;

    If (Not LastCoord) then {* Attempt to store last coord *}
      HLite:=ColOrd;

    StorebtControlCsm(Self);

    StorebtControlCsm(PageControl1);

    StorebtControlCsm(I1SBox);

    StorebtControlCsm(I1BSBox);

    StorebtControlCsm(I1BtnPanel);

    StorebtControlCsm(I1ListBtnPanel);

    StorebtControlCsm(I1AccF);

    MULCtrlO.Store_ListCoord(GlobComp);

    If Assigned(PayCtrl) then
      PayCtrl.MULCtrlO.Store_ListCoord(GlobComp);
  end; {With GlobComp..}

  Dispose(GlobComp,Destroy);

  Store_Page1Coord(UpMode);
End; { Store_FormCoord }

//-------------------------------------------------------------------------

procedure TfrmSOPTrans.Store_Page1Coord(UpMode  :  Boolean);
Var
  n       :  Byte;
  GlobComp:  TGlobCompRec;
Begin
  New(GlobComp,Create(BOff));

  With GlobComp^ do
  Begin

    GetValues:=UpMode;

    SaveCoord:=StoreCoord;

    PrimeKey:=LowerCase(DocCodes[ExLocal.LInv.InvDocHed])[1];

    For n:=1 to High(MULVisiList) do
    If (MULVisiList[n]<>nil) then
    With MULCtrlO do
    Begin
      VisiList:=MULVisiList[n];

      Store_ListCoord(GlobComp);

      StorebtControlCsm(VisiList.LabHedPanel); {* Move to object store *}
    end;


    If (Current_Page<=High(MULVisiList)) then
      With MULCtrlO do
      Begin
        VisiList:=MULVisiList[Current_Page];
      end;

  end; {With GlobComp..}

  Dispose(GlobComp,Destroy);
end;

//-------------------------------------------------------------------------

procedure TfrmSOPTrans.PropFlgClick(Sender: TObject);
begin
  If (Current_Page = 5) And Assigned(PayCtrl) Then
    PayCtrl.SetFormProperties
  Else Begin
    SetFormProperties((N3.Tag=99));
    N3.Tag:=0;
  End; { Else }
end;

//------------------------------

procedure TfrmSOPTrans.StoreCoordFlgClick(Sender: TObject);
begin
  StoreCoord:=Not StoreCoord;
  NeedCUpdate:=BOn;
end;

//-------------------------------------------------------------------------

procedure TfrmSOPTrans.SetFormProperties(SetList  :  Boolean);
Const
  PropTit     :  Array[BOff..BOn] of Str5 = ('Form','List');
Var
  TmpPanel    :  Array[1..3] of TPanel;
  n           :  Byte;
  ResetDefaults,
  BeenChange  :  Boolean;
  ColourCtrl  :  TCtrlColor;
Begin
  ResetDefaults:=BOff;

  For n:=1 to 3 do
  Begin
    TmpPanel[n]:=TPanel.Create(Self);
  end;

  try
    If (SetList) then
    Begin
      With MULCtrlO.VisiList do
      Begin
        VisiRec:=List[0];

        TmpPanel[1].Font:=(VisiRec^.PanelObj as TSBSPanel).Font;
        TmpPanel[1].Color:=(VisiRec^.PanelObj as TSBSPanel).Color;

        TmpPanel[2].Font:=(VisiRec^.LabelObj as TSBSPanel).Font;
        TmpPanel[2].Color:=(VisiRec^.LabelObj as TSBSPanel).Color;


        TmpPanel[3].Color:=MULCtrlO.ColAppear^[0].HBKColor;
      end;

      TmpPanel[3].Font.Assign(TmpPanel[1].Font);

      TmpPanel[3].Font.Color:=MULCtrlO.ColAppear^[0].HTextColor;
    end
    else
    Begin
      TmpPanel[1].Font:=I1AccF.Font;
      TmpPanel[1].Color:=I1AccF.Color;

      TmpPanel[2].Font:=I1FPanel.Font;
      TmpPanel[2].Color:=I1FPanel.Color;
    end;

    ColourCtrl:=TCtrlColor.Create(Self);

    try
      With ColourCtrl do
      Begin
        SetProperties(TmpPanel[1],TmpPanel[2],TmpPanel[3],Ord(SetList),Self.Caption+' '+PropTit[SetList]+' Properties',BeenChange,ResetDefaults);

        NeedCUpdate:=(BeenChange or ResetDefaults);

        If (BeenChange) and (not ResetDefaults) then
        Begin

          If (SetList) then
          Begin
            For n:=1 to 3 do
              With TmpPanel[n] do
                Case n of
                  1,2  :  MULCtrlO.ReColorCol(Font,Color,(n=2));

                  3    :  MULCtrlO.ReColorBar(Font,Color);
                end; {Case..}

            MULCtrlO.VisiList.LabHedPanel.Color:=TmpPanel[2].Color;
          end
          else
          Begin
            I1FPanel.Font.Assign(TmpPanel[2].Font);
            I1FPanel.Color:=TmpPanel[2].Color;

            I1AccF.Font.Assign(TmpPanel[1].Font);
            I1AccF.Color:=TmpPanel[1].Color;

            SetFieldProperties;
          end;
        end;
      end;
    finally
      ColourCtrl.Free;
    end;
  Finally
    For n:=1 to 3 do
      TmpPanel[n].Free;
  end;

  If (ResetDefaults) then
  Begin
    SetDefault:=BOn;
    Close;
  end;
end;

//-------------------------------------------------------------------------

procedure TfrmSOPTrans.SetFieldProperties;
Var
  n  : Integer;
Begin
  I1BtmPanel.Color:=I1FPanel.Color;
  I2BtmPanel.Color:=I1FPanel.Color;
  I3BtmPanel.Color:=I1FPanel.Color;
  I4BtmPanel.Color:=I1FPanel.Color;
  I1BtnPanel.Color:=I1FPanel.Color;
  //I1BtnPanel2.Color:=I1FPanel.Color;
  {SBSPanel64.Color:=I1FPanel.Color;}
  SBSPanel53.Color:=I1FPanel.Color;
  SBSPAnel55.Color:=I1FPanel.Color;

  For n:=0 to Pred(ComponentCount) do
  Begin
    If (Components[n] is TMaskEdit) or (Components[n] is TComboBox)
     or (Components[n] is TCurrencyEdit) and (Components[n]<>I1AccF) then
    With TGlobControl(Components[n]) do
      If (Tag>0) then
      Begin
        Font.Assign(I1AccF.Font);
        Color:=I1AccF.Color;
      end;

    If (Components[n] is TBorCheck) then
      With (Components[n] as TBorCheck) do
      Begin
        CheckColor:=I1AccF.Color;
        Color:=I1FPanel.Color;
      end;
  end; {Loop..}

  I1AddrF.Color:=I1AccF.Color;
  I1AddrF.Font.Assign(I1AccF.Font);
end;

//-------------------------------------------------------------------------

procedure TfrmSOPTrans.Find_FormCoord;
Var
  ThisForm    : TForm;
  VisibleRect : TRect;
  GlobComp    : TGlobCompRec;
Begin
  New(GlobComp,Create(BOn));

  ThisForm:=Self;

  With GlobComp^ do
  Begin
    GetValues:=BOn;

    PrimeKey:=LowerCase(DocCodes[ExLocal.LInv.InvDocHed])[1];

    If (GetbtControlCsm(ThisForm)) then
    Begin
      StoreCoord:=BOff;
      HasCoord:=(HLite=1);
      LastCoord:=HasCoord;

      If (HasCoord) then {* Go get postion, as would not have been set initianly *}
        SetPosition(ThisForm);
    end;

    GetbtControlCsm(PageControl1);

    GetbtControlCsm(I1SBox);

    GetbtControlCsm(I1BSBox);

    GetbtControlCsm(I1BtnPanel);

    GetbtControlCsm(I1ListBtnPanel);

    If GetbtControlCsm(I1AccF) then
      SetFieldProperties;

    MULCtrlO.Find_ListCoord(GlobComp);
  end; {With GlobComp..}

  Dispose(GlobComp,Destroy);

  {NeedCUpdate}
  StartSize.X:=Width; StartSize.Y:=Height;
end;

//-------------------------------------------------------------------------

procedure TfrmSOPTrans.PopupMenu1Popup(Sender: TObject);
begin
  StoreCoordFlg.Checked:=StoreCoord;
end;

//-------------------------------------------------------------------------

procedure TfrmSOPTrans.FormSetOfSet;
Begin
  PagePoint[0].X:=ClientWidth-(PageControl1.Width);
  PagePoint[0].Y:=ClientHeight-(PageControl1.Height);

  PagePoint[1].X:=PageControl1.Width-(I1SBox.Width);
  PagePoint[1].Y:=PageControl1.Height-(I1SBox.Height);

  PagePoint[2].X:=PageControl1.Width-(I1BtnPanel.Left);
  PagePoint[2].Y:=PageControl1.Height-(I1BtnPanel.Height);

  PagePoint[3].X:=I1BtnPanel.Height-(I1BSBox.Height);
  PagePoint[3].Y:=I1SBox.ClientHeight-(I1StkCodePanel.Height);

  PagePoint[4].X:=PageControl1.Width-(I1ListBtnPanel.Left);
  PagePoint[4].Y:=PageControl1.Height-(I1ListBtnPanel.Height);

  PagePoint[6].X:=PageControl1.Height-(RcListBtnPanel.Height);

  GotCoord:=BOn;
end;

//-------------------------------------------------------------------------

procedure TfrmSOPTrans.ClsI1BtnClick(Sender: TObject);
begin
  Close;
end;

//-------------------------------------------------------------------------

procedure TfrmSOPTrans.btnViewLineClick(Sender: TObject);
Var
  OK : Boolean;
begin
  // Check not footer
  If (Current_Page <> 4) Then Begin
    If (Current_Page = 5) Then Begin
      OK := Assigned(PayCtrl) And PayCtrl.MULCtrlO.ValidLine;
      //If OK Then PayCtrl.MULCtrlO.RefreshLine(MUListBoxes[0].Row,BOff);
    End { If (Current_Page = 5)  }
    Else Begin
      OK := MULCtrlO.ValidLine;
      If OK Then MULCtrlO.RefreshLine(MULCtrlO.MUListBoxes[0].Row,BOff);
    End; { Else }

    If OK Then Display_Id (Id, False);
  End; { If (Current_Page <> 4) }
end;

//-------------------------------------------------------------------------

procedure TfrmSOPTrans.Display_Id (Const TheId : IDetail; Const DataChanged : Boolean);
Begin { Display_Id }
  If (TheId.LineNo=RecieptCode) Then Begin
    // Receipt/Payment Line
    If PayCtrl.Visible Or (Not DataChanged) Then
      PayCtrl.AddEditPay(True,True,0,0,ExLocal.LInv);
  End { If (TheId.LineNo=RecieptCode) }
  Else Begin
    // Sale/Purchase Line
    // Create form if required
    If (Not Assigned(IdLine)) And (Not DataChanged) Then
      IDLine := TfrmSOPLine.Create(Self);

    If Assigned(IdLine) Then
      // Display Transaction Line
      IdLine.DisplayId(ExLocal.LInv, TheId);
  End; { Else }
End; { Display_Id }

//-------------------------------------------------------------------------

// MH 26/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount withdrawn from 01/04/2015
Procedure TfrmSOPTrans.ShowSettlementDiscountFields (Const ShowFields : Boolean);
Begin // ShowSettlementDiscountFields
  // MH 20/03/2015 v7.0.14 ABSEXCH-16284: Added Prompt Payment Discount fields
  If ShowFields Then
    nbSettleDisc.PageIndex := SettleDiscPage   // Settlement Discount
  Else
    // MH 19/05/2015 v7.0.14 ABSEXCH-16284: Hide PPD fields for non-qualifying transactions or if disabled on the account
    DisplayPPDFields;
End; // ShowSettlementDiscountFields

//-------------------------------------------------------------------------

// MH 19/05/2015 v7.0.14 ABSEXCH-16284: Hide PPD fields for non-qualifying transactions or if disabled on the account
Function TfrmSOPTrans.ShowPPDFields : Boolean;
Begin // ShowPPDFields
  // Filter by transaction type
  Result := (ExLocal.LInv.InvDocHed In PPDTransactions);

  // Look at PPD Mode on account (if loaded) - need to format LInv.CustCode as it may contain exactly what the user typed, e.g. lowercase!
  If Result And (Trim(ExLocal.LCust.CustCode) <> '') And (FullCustCode(ExLocal.LCust.CustCode) = FullCustCode(ExLocal.LInv.CustCode)) Then
    Result := (ExLocal.LCust.acPPDMode <> pmPPDDisabled);
End; // ShowPPDFields

//------------------------------

// MH 19/05/2015 v7.0.14 ABSEXCH-16284: Hide PPD fields for non-qualifying transactions or if disabled on the account
Procedure TfrmSOPTrans.DisplayPPDFields;
Begin // DisplayPPDFields
  // MH 27/05/2015 v7.0.14: Added the No-PPD Page to allow for a different listview layout
  //                        without having to do it all at runtime
  If ShowPPDFields Then
  Begin
    // Prompt Payment Discount
    nbSettleDisc.PageIndex := PromptPaymentDiscountPage;

    // Only show the status information on Invoices - you cannot take PPD against any other
    // transactions so it doesn't make sense
    shapePPDStatus.Visible := lblPromptPaymentDiscountHeader.Visible And (ExLocal.LInv.InvDocHed In [SIN, SJI, PIN, PJI]);
    lblPPDStatus.Visible := shapePPDStatus.Visible;
  End // If ShowPPDFields
  Else
    // Prompt Payment Discount Disabled by Transaction Type or Account
    nbSettleDisc.PageIndex := NoPromptPaymentDiscountPage;
End; // DisplayPPDFields

//------------------------------

// MH 19/05/2015 v7.0.14 ABSEXCH-16284: Hide PPD fields for non-qualifying transactions or if disabled on the account
Procedure TfrmSOPTrans.UpdatePPDStatusInfo;
Begin // UpdatePPDStatusInfo
  With ExLocal.LInv Do
  Begin
    Case thPPDTaken Of
      ptPPDNotTaken          : Begin
	                             // MH 18/06/2015 v7.0.14 ABSEXCH-16554: Updated PPD status field on transaction footer for changes in Enter1  
                                 // MH 28/05/2015 v7.0.14 ABSEXCH-16468: Zero value SIN showing 'Status: Available'
                                 // PR: 03/06/2015 v7.0.14 ABSEXCH-16486 Zero vat invoice showing 'Status: Not Available'
                                 If (thPPDPercentage <> 0.0) And (thPPDGoodsValue <> 0.0) Then
                                 Begin
                                   // Check Transaction's Oustanding Value equals/exceeds the PPD Value
                                   //PR: 03/06/2015 ABSEXCH-16476 Remove sign so comparision works for Purchase transactions
                                   If (Abs(CurrencyOS(ExLocal.LInv, True {Round to 2dp}, False {Convert to Base}, False {UseCODay})) >= Round_Up(ExLocal.LInv.thPPDGoodsValue + ExLocal.LInv.thPPDVATValue, 2)) Then
                                   Begin
                                     // PPD Value is <= Outstanding Value so it could still be taken
                                     If (CalcDueDate(TransDate, thPPDDays) >= Today) Then
                                       lblPPDStatus.Caption := 'Status: Available'
                                     Else
                                       lblPPDStatus.Caption := 'Status: Expired';
                                   End // If (CurrencyOS(ExLocal.LInv, ...
                                   Else
                                     // Transaction's Outstanding value is less than the PPD Value so it can no longer be taken
                                     lblPPDStatus.Caption := 'Status: Not Taken';
                                 End // If (thPPDPercentage <> 0.0) And (thPPDGoodsValue <> 0.0) And (thPPDVATValue <> 0.0) 
                                 Else
                                   lblPPDStatus.Caption := 'Status: Not Available'
                               End; // ptPPDNotTaken
      ptPPDTaken             : lblPPDStatus.Caption := 'Status: Taken';
      ptPPDTakenOutsideTerms : lblPPDStatus.Caption := 'Status: Taken/Expired';
    Else
      lblPPDStatus.Caption := 'Status: Unknown';
    End; // Case thPPDTaken
  End; // With ExLocal.LInv
End; // UpdatePPDStatusInfo

//-------------------------------------------------------------------------

end.

