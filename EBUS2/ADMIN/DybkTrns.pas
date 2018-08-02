unit DybkTrns;

{ prutherford440 09:44 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, SBSPanel, ComCtrls, StdCtrls, TEditVal, Mask, BorBtns, Buttons,
  GlobVar, VarConst, ExWrap1U, BTSupU1, SupListU, SBSComp, SBSComp2,
  Menus, bkgroup, AccelLbl, BtrvList, DybkLine, EBusCnst, ActnList, EntUtil,
  AdmUtl2, NoteU, TTD;

type
  TEBusLinesList = class(TGenList)
    public
      function SetCheckKey : Str255; override;
      function OutLine(Col : byte) : str255; override;
  end;

  TfrmOneTransaction = class(TForm)
    pgcOneTransaction: TPageControl;
    tabMain: TTabSheet;
    sbxMain: TScrollBox;
    pnlQty: TSBSPanel;
    pnlStk: TSBSPanel;
    pnlDesc: TSBSPanel;
    pnlLT: TSBSPanel;
    pnlUPrc: TSBSPanel;
    pnlVAT: TSBSPanel;
    pnlColumnHeaders: TSBSPanel;
    pnlStkHead: TSBSPanel;
    pnlQtyHead: TSBSPanel;
    pnlUPrcHead: TSBSPanel;
    pnlDiscHead: TSBSPanel;
    pnlVATHead: TSBSPanel;
    pnlDescHead: TSBSPanel;
    pnlListControls: TSBSPanel;
    pnlDisc: TSBSPanel;
    pnlLTHead: TSBSPanel;
    tabFooter: TTabSheet;
    pnlFooterVAT: TSBSPanel;
    pnlVATTitle: TSBSPanel;
    I5VATRLab: TLabel;
    Label8: TLabel;
    I5VATLab: TLabel;
    pnlButtons: TSBSPanel;
    sbxButtons: TScrollBox;
    btnEdit: TButton;
    btnDelete: TButton;
    btnInsert: TButton;
    btnAdd: TButton;
    pnlFooterButtons: TSBSPanel;
    tabNotes: TTabSheet;
    TCNScrollBox: TScrollBox;
    TNHedPanel: TSBSPanel;
    NDateLab: TSBSPanel;
    NDescLab: TSBSPanel;
    NUserLab: TSBSPanel;
    NDatePanel: TSBSPanel;
    NDescPanel: TSBSPanel;
    NUserPanel: TSBSPanel;
    TCNListBtnPanel: TSBSPanel;
    pnlHeader: TSBSPanel;
    Label84: Label8;
    I1CurrLab: Label8;
    Label81: Label8;
    I1ExLab: Label8;
    Label88: Label8;
    Label817: Label8;
    btnDelivery: TSpeedButton;
    I1DueDateL: Label8;
    edtOurRef: Text8Pt;
    edtOperator: Text8Pt;
    edtACCode: Text8Pt;
    edtTransDate: TEditDate;
    edtDueDate: TEditDate;
    edtExchRate: TCurrencyEdit;
    edtPeriod: TEditPeriod;
    cbxCurrency: TSBSComboBox;
    mnuPopUp: TPopupMenu;
    mniAdd: TMenuItem;
    mniEdit: TMenuItem;
    N2: TMenuItem;
    mniProperties: TMenuItem;
    N1: TMenuItem;
    mniSaveOnExit: TMenuItem;
    N3: TMenuItem;
    mniInsert: TMenuItem;
    I1BtmPanel: TSBSPanel;
    Label813: Label8;
    lblCC: Label8;
    lblDept: Label8;
    lblLocation: Label8;
    Label819: Label8;
    I1VATTLab: Label8;
    Label821: Label8;
    edtGLCodeDesc: Text8Pt;
    edtCCCode: Text8Pt;
    edtDepCode: Text8Pt;
    edtLocCode: Text8Pt;
    edtNetTotal: TCurrencyEdit;
    edtVATContent: TCurrencyEdit;
    edtGrossTotal: TCurrencyEdit;
    chkVATAmended: TBorCheck;
    mniDelete: TMenuItem;
    lblCurrency: Label8;
    chkFixedRate: TBorCheck;
    btnClose: TButton;
    btnCancel: TButton;
    btnOK: TButton;
    I1YrRefL: Label8;
    edtYourRef: Text8Pt;
    edtAltRef: Text8Pt;
    I1YrRef2L: Label8;
    pnlViewStatus: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    actDaybookTrans: TActionList;
    actAddLine: TAction;
    actEditLine: TAction;
    actDeleteLine: TAction;
    memAddress: TMemo;
    btnCloseFooter: TButton;
    btnCancelFooter: TButton;
    btnOKFooter: TButton;
    Label834: Label8;
    edtControlNom: Text8Pt;
    actCancel: TAction;
    sbxVATAnalysis: TScrollBox;
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
    btnSwitch: TButton;
    btnApplyTTD: TButton;
    lvLineTypeTotals: TListView;
    nbSettleDisc: TNotebook;
    SBSPanel55: TSBSBackGroup;
    Label3: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    edtSettleDiscPercent: TCurrencyEdit;
    edtSettleDiscDays: TCurrencyEdit;
    SBSPanel63: TSBSPanel;
    SBSPanel1: TSBSPanel;
    SBSPanel62: TSBSPanel;
    SBSPanel2: TSBSPanel;
    edtNoSettleNet: TCurrencyEdit;
    edtNoSettleVAT: TCurrencyEdit;
    edtNoSettleDisc: TCurrencyEdit;
    edtNoSettleTotal: TCurrencyEdit;
    edtSettleTotal: TCurrencyEdit;
    edtSettleDisc: TCurrencyEdit;
    edtSettleVAT: TCurrencyEdit;
    edtSettleNet: TCurrencyEdit;
    chkSettleDiscTaken: TCheckBox;
    lblPromptPaymentDiscountHeader: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Bevel2: TBevel;
    Label31: TLabel;
    Bevel3: TBevel;
    ccyPPDPercentage: TCurrencyEdit;
    ccyPPDDays: TCurrencyEdit;
    lvTransactionTotals: TListView;
    shapePPDStatus: TShape;
    lblPPDStatus: TLabel;
    pnlIntrastat: TPanel;
    Label4: TLabel;
    Bevel5: TBevel;
    lblDeliveryTerms: TLabel;
    lblTransactionType: TLabel;
    lblNoTc: TLabel;
    lblModeOfTransport: TLabel;
    cbDeliveryTerms: TSBSComboBox;
    cbTransactionType: TSBSComboBox;
    cbNoTc: TSBSComboBox;
    cbModeOfTransport: TSBSComboBox;
    SBSPanel54: TSBSPanel;
    SBSPanel3: TSBSPanel;
    SBSPanel4: TSBSPanel;
    SBSPanel5: TSBSPanel;
    procedure pgcOneTransactionChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure HeadersMouseDownExecute(Sender: TObject; Button: TMouseButton;
                Shift: TShiftState; X, Y: Integer);
    procedure HeadersMouseMoveExecute(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure MoveAlignColsExecute(Sender: TObject; Button: TMouseButton;
                Shift: TShiftState; X, Y: Integer);
    procedure mniSaveOnExitClick(Sender: TObject);
    procedure mniPropertiesClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnDeliveryClick(Sender: TObject);
    procedure actAddLineExecute(Sender: TObject);
    procedure actEditLineExecute(Sender: TObject);
    procedure actDeleteLineExecute(Sender: TObject);
    procedure btnInsertClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure edtACCodeExit(Sender: TObject);
    procedure cbxCurrencyExit(Sender: TObject);
    procedure edtTransDateExit(Sender: TObject);
    procedure edtPeriodExit(Sender: TObject);
    procedure edtDueDateExit(Sender: TObject);
    procedure edtYourRefExit(Sender: TObject);
    procedure edtAltRefExit(Sender: TObject);
    procedure edtExchRateExit(Sender: TObject);
    procedure chkFixedRateClick(Sender: TObject);
    procedure CheckTraderDependencies;
    procedure edtControlNomExit(Sender: TObject);
    procedure actCancelExecute(Sender: TObject);
    procedure I5VV1FExit(Sender: TObject);
    procedure chkVATAmendedMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure btnSwitchClick(Sender: TObject);
    procedure btnApplyTTDClick(Sender: TObject);
    procedure edtSettleDiscPercentExit(Sender: TObject);
    procedure chkSettleDiscTakenMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ccyPPDPercentageExit(Sender: TObject);
    procedure chkPPDTakenClick(Sender: TObject);
  private
    fVATRateUsed : IVATAnalType; // Whether particular VAT code in use
    fVATGoods : array[VATType] of double;     // Line Totals per VAT code
    FormStuff : TFormStuff;
    frmTransactionLine : TfrmTransactionLine;
    fEditMode : TFormActivate;
    fExLocalTransHead : ^TExLocalEBus;
    fDoingClose,
    fHeaderChanged : boolean;

    VATMatrix    :  TVATMatrix;

    NotesCtrl  :  TNoteCtrl;
    YrRefToAltRef : Boolean;
    TTDHelper : TTTDTransactionHelper;

    FLineTypeCaptions : Array[1..4] of string;

    procedure SetLineTypeCaptions;
    function  TraderControlNomSet(const TraderCode : string) : boolean;
    function  CancellingEdits : boolean;
    procedure InitialFormSetup;
    procedure EnableVATEditing;
    procedure ShowLineDetailsForm(Mode : TFormActivate);
    procedure TransactionLineUpdated;
    procedure WMCustGetRec(var Message : TMessage); message WM_CustGetRec;
    procedure WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo); message WM_GetMinMaxInfo;
    procedure WMSysCommand(var Message : TMessage); message WM_SysCommand;
    procedure WMFormCloseMsg(var Message : TMessage); message WM_FormCloseMsg;
    procedure CalcHeaderTotals;
    procedure RefreshVATAnalysis;
    procedure RefreshTraderAddress(CCode  :  Str10);

    procedure RefreshTransHeader;
    procedure RefreshList;
    procedure SetEditMode(Value : TFormActivate);
    procedure UpdateDisplay;
    procedure CloseForm(ViaDestroy  :  Boolean);
    procedure CloseTransaction;
    procedure RecalculateHeaderFromLines;
    procedure MustBeSaved;
    procedure EnableEditing;
    procedure SetBoolean(const Index: Integer; const Value: boolean);
    procedure Form2Inv;
    procedure SaveHeader;
    procedure ExchangeRateEnabled;
    procedure ShowSettlementDiscountFields;

    //PR: 01/02/2016 ABSEXCH-17116 v2016 R1 Sets Intrastat controls correctly
    procedure ArrangeIntrastatControls;


    //PR: 01/02/2016 ABSEXCH-17116 v2016 R1 Load Intrastat lists
    procedure PopulateIntrastatLists;

    //PR: 01/02/2016 ABSEXCH-17116 v2016 R1 Copy Intrastat fields from transaction to form
    procedure TransIntrastatToForm;

    //PR: 01/02/2016 ABSEXCH-17116 v2016 R1 Copy Intrastat fields from form to transaction
    procedure FormIntrastatToTrans;

    //PR: 01/02/2016 ABSEXCH-17116 v2016 R1 Set Intrastat fields on transaction to defaulta
    procedure DefaultIntrastat;
  protected
    property  HeaderChanged : boolean index 1 read fHeaderChanged write SetBoolean;
  public
    property  EditMode : TFormActivate read fEditMode write SetEditMode;
    procedure RefreshDetails;
    procedure ReadTransaction;
    procedure UpdatePPDStatusInfo;
  end;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

{$R *.DFM}

uses
  BtKeys1U, AdmnUtil, EBusUtil, UseDLLU, UseTKit, TKitUtil,
  MathUtil, StrUtil, EBusVar, DelAddr, ComnUnit, BtrvU2, MiscU,
  ETMiscU,InvFSu3U, BTSupU2, IntStatH, EntLkup, PostTran, EbusBtrv,
  SysU2, TransactionHelperU, CurrncyU, EtDateU, PromptPaymentDiscountFuncs,
  oSystemSetup, IntrastatXML, IntStatU, CountryCodes;

const
  DEF_CLIENT_HEIGHT = 356;
  DEF_CLIENT_WIDTH = 633;
  BASE_FORM_LETTER = 'D';

  SettleDiscPage = 0;
  PromptPaymentDiscountPage = 1;


//-----------------------------------------------------------------------

function TEBusLinesList.SetCheckKey : Str255;
Var
  TmpLNo,
  TmpRunNo,
  TmpFolio  :  LongInt;

begin
  FillChar(Result,Sizeof(Result),#0);

  If (UseSet4End) and (CalcEndKey) then  {* If A special end key calculation is needed *}
  Begin
    TmpLNo:=MaxLInt;

  end
  else
    TmpLNo:=Id.LineNo;


  with ID do
    Result := FullNomKey(FolioRef) + FullNomKey(TmpLNo);
end;

//-----------------------------------------------------------------------

function TEBusLinesList.OutLine(Col : byte) : str255;

Var
  LineTotal  :  Double;

  function FormatDiscount(Value : Real; Chr : Char) : string;
  begin
    //PR: 07/02/2012 Remove '//' formatting from zero discounts. Fixed while coding ABSEXCH-2748
    if ZeroFloat(Value, 4) then
      Result := ''
    else
    if Chr = '%' then
      Result := FloatToStrF(Ex_RoundUp((Value * 100), 2), ffFixed, 18, 2) + '%'
    else
      Result := ToFixedDP(Value, 2);
  end;

begin
  with ID do
  begin
    If (Col=3) then
      LineTotal:=GetLineTotal(Id, True, {Inv.DiscSetl}0)
    else
      LineTotal:=0.0;

    Result := '';
    //PR: 01/02/2012 Bom components have KitLink <> 0, so display values (ABSEXCH-2748)
    if (KitLink = 0) or (Trim(StockCode) <> '') then
      case Col of
        0: Result := StockCode;
        1: If (Qty<>0.0) then
             Result:=ToFixedDP(Qty, CurCompSettings.QuantityDP);
        2: Result := Desc;
        3: If (LineTotal<>0.0) then
             Result := ToFixedDP(LineTotal, 2);
        4: if VATCode <> #0 then
             Result := VATCode;
        5: If (NetValue<>0.0) then
             Result:=ToFixedDP(NetValue, CurCompSettings.PriceDP);
(*        6: if DiscountChr = '%' then
             Result := FloatToStrF(Ex_RoundUp((Discount * 100), 2), ffFixed, 18, 2) + '%'
           else
             Result := ToFixedDP(Discount, 2); *)
        6:  begin //PR: 21/07/2009 Change to display all discounts
              Result := FormatDiscount(Discount,DiscountChr) + '/' +
                        FormatDiscount(Discount2,Discount2Chr) + '/' +
                        FormatDiscount(Discount3,Discount3Chr);
              if Result = '//' then
                Result := '';
            end;
      end // case
    else // It's an additional description line
      if Col = 2 then
        Result := Desc;
  end;
end;

//=======================================================================

procedure TfrmOneTransaction.SetBoolean(const Index: Integer; const Value: boolean);
begin
  case Index of
    1: fHeaderChanged := Value;  // i.e. the transaction header has changed
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.SetEditMode(Value: TFormActivate);
begin
  // Only coded to allow for actEdit and actShow, so raise exception otherwise
  if not (Value in [actEdit, actShow]) then
    raise Exception.Create('EditMode must be actEdit or actShow');
  fEditMode := Value;
  pnlViewStatus.Visible := fEditMode = actShow;
  // Later maybe process these buttons so that they disappear when in view mode
  btnAdd.Enabled := fEditMode <> actShow;
  btnInsert.Enabled := fEditMode <> actShow;
  btnDelete.Enabled := fEditMode <> actShow;

  Case fEditMode of
     actShow   : TTDHelper.TransactionMode := tmView;
     actEdit   : TTDHelper.TransactionMode := tmEdit;
     actAdd,
     actInsert : TTDHelper.TransactionMode := tmAdd;
  end;

  btnApplyTTD.Enabled := (fEditMode <> actShow) and TTDHelper.Enabled;
  with TShuffleButtons.Create(sbxButtons) do
  try
    ShuffleButtons;
  finally
    Free;
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.CalcHeaderTotals;
var
  KeyS : str255;
  Status : integer;
  ExLocal : ^TExLocalEBus;
  v : VATType;
begin
  // Initialise totals

  FillChar(fVATRateUsed,sizeof(fVATRateUsed),0);
 FillChar(fVATGoods,sizeof(fVATGoods),0);

{   for v := Standard to Rate18 do
    fExLocalTransHead^.LInv.InvVatAnal[v] := 0;}

  new(ExLocal, Create(CLIENT_ID_LOCAL));
  with ExLocal^ do
  begin
    ShowErrors := true;
    OpenOneFile(IDetailF, CurCompSettings.CompanyPath, EBUS_DETAILNAME);
    KeyS := FullRunNoKey(fExLocalTransHead^.LInv.FolioNum, 1);
    Status := ExLocal^.LFind_Rec(B_GetGEq, IDetailF, 0, KeyS);
    while (Status = 0) and (LId.FolioRef = fExLocalTransHead^.LInv.FolioNum) do
    begin
      v := VATCodeToVATType(LId.VATCode);
      fVATRateUsed[v] := true;
      // Quantity multipliers ???
      fVATGoods[v] := fVATGoods[v] + Round_Up((GetLineTotal(Lid, true, 0)),2);
//        fExLocalTransHead^.LInv.DiscSetl));
//      fExLocalTransHead^.LInv.InvVatAnal[v] := fExLocalTransHead^.LInv.InvVatAnal[v] + LId.VAT;
      Status := ExLocal^.LFind_Rec(B_GetNext, IDetailF, 0, KeyS);
    end;
    CloseSelFiles([IDetailF]);



  end;
  dispose(ExLocal, destroy);
end;

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.WMCustGetRec(var Message : TMessage);
begin
  with Message do
    case WParam of
      0: // Double click
         ShowLineDetailsForm(EditMode);
      1: // Row with data gets focus
         // Message relaying to avoid problems with mouse up event
         begin
           PostMessage(Self.Handle, WM_FormCloseMsg,1000+WParam,0);
         end;
      2: // Right click
          mnuPopup.PopUp(LParamLo, lParamHi);

     176 :  Case LParam of
              0  :  Case pgcOneTransaction.ActivePageIndex  of
                      2  :  If (Assigned(NotesCtrl)) then
                                NotesCtrl.MULCtrlO.SetListFocus;
                    end; {Case..}
            end; {Case..}

      200: // Add / update performed
          Begin
            with FormStuff.aMUlCtrlO[0] do
              AddNewRow(MUListBoxes[0].Row,(LParam=1));

            UpdateDisplay;
            MustBeSaved;

            FormStuff.aMUlCtrlO[0].SetListFocus;
          end;

      300: // Delete performed
          RefreshList;
      EBUS_FORM_CLOSE:
        begin
          frmTransactionLine := nil;
          if LParam = FORM_TRANS_LINE_OK then

        end;
    end; // case
end;

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.UpdateDisplay;
begin
  CalcHeaderTotals;
  RefreshTransHeader;
  RefreshVATAnalysis;
  ShowSettlementDiscountFields;
end;

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.RefreshList;
// Notes : Call to redisplay the items in the list e.g. after removal etc.
begin
 // Only works for single line adding
 // TRUE = ADD - new row added
 // FALSE = EDIT - row already there but info changed
 // FormStuff.aMULCtrlO[0].AddNewRow(FormStuff.aMULCtrlO[0].MUListBoxes[0].Row,FALSE);

 with FormStuff.aMulCtrlO[0] do
  if (MUListBox1.Row = 0) or (not ValidLine) then
    InitPage
  else
    PageUpDn(0, true)
end;

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.RefreshDetails;
begin
  if EditMode = actShow then
  begin
    CloseTransaction;
    ReadTransaction;
    with FormStuff do
    begin
      aKeyStart[0] := FullNomKey(Inv.FolioNum);
      aMULCtrlO[0].StartList(aFileNos[0], aiKeys[0], aKeyStart[0], aKeyEnd[0],
          '', aKeyLength[0], FALSE);
    end;
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.ShowLineDetailsForm(Mode : TFormActivate);
var
  ShowForm : boolean;
begin
  ShowForm := Mode = actAdd;
  if (Mode in [actEdit, actInsert, actShow]) and (FormStuff.aMulCtrlO[0].ValidLine) then
  begin
    with FormStuff.aMULCtrlO[0] do
      RefreshLine(MUListBoxes[0].Row, false);
    ShowForm := not Assigned(frmTransactionLine);
  end;

  if ShowForm then
  begin
    frmTransactionLine := TfrmTransactionLine.Create(self);
    frmTransactionLine.HeaderRec := @fExLocalTransHead^.LInv;
    frmTransactionLine.InitialiseForm(Mode);
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.pgcOneTransactionChange(Sender: TObject);
var
  NoteSetUp :  TNotePadSetUp;
  i : integer;
begin
  pnlHeader.Visible := not (pgcOneTransaction.ActivePage = tabFooter);
  pnlButtons.Visible := not (pgcOneTransaction.ActivePage = tabFooter);

  btnSwitch.Enabled :=  pgcOneTransaction.ActivePage = tabNotes;
  btnSwitch.Visible :=  pgcOneTransaction.ActivePage = tabNotes;
  with TShuffleButtons.Create(sbxButtons) do
  try
    ShuffleButtons;
  finally
    Free;
  end;


  if pgcOneTransaction.ActivePage = tabNotes then
  If (NotesCtrl=nil) then
      With fExLocalTransHead^ do
      Begin
        NotesCtrl:=TNoteCtrl.Create(Self);

        NotesCtrl.Caption:=Caption+' - Notes';

        FillChar(NoteSetup,Sizeof(NoteSetUp),0);
        With NoteSetUp do
        Begin
          ColPanels[0]:=NDatePanel; ColPanels[1]:=NDateLab;
          ColPanels[2]:=NDescPanel; ColPanels[3]:=NDescLab;
          ColPanels[4]:=NUserPanel; ColPanels[5]:=NUserLab;

          ColPanels[6]:=TNHedPanel;
          ColPanels[7]:=TcNListBtnPanel;

          ScrollBox:=TCNScrollBox;
        //  PropPopUp:=StoreCoordFlg;

        //  CoorPrime:=DocCodes[DocHed][1];
        //  CoorHasCoor:=LastCoord;

        end;

        try
          NotesCtrl.CreateList(Self,NoteSetUp,NoteDCode,NoteCDCode,FullNomKey(LInv.FolioNum));
          NotesCtrl.GetLineNo:=LInv.NLineCount;

        except
          NotesCtrl.Free;
          NotesCtrl:=Nil
        end;


      end
      else
      With fExLocalTransHead^ do
        If (FullNomKey(LInv.FolioNum)<>NotesCtrl.GetFolio) then {* Refresh notes *}
        with NotesCtrl do
        Begin
          RefreshList(FullNomkey(LInv.FolioNum),GetNType);
          GetLineNo:=LInv.NLineCount;
        end;

end;


//-----------------------------------------------------------------------

procedure TfrmOneTransaction.CloseForm(ViaDestroy  :  Boolean);
begin
  If (Not fDoingClose) and  (Not Application.Terminated) then
  Begin
    fDoingClose:=BOn;


    If (Assigned(FormStuff)) and (Not ViaDestroy) then
    Begin
      with FormStuff do
      StoreFormProperties(Self, FormStuff, bStoreCoord, bSetDefaults, bLastCoord, BASE_FORM_LETTER);

      FormStuff.Free;
      FormStuff:=nil;
    end;

    if Assigned(NotesCtrl) then
      FreeAndNil(NotesCtrl);

    If (Assigned(VATMAtrix)) then
      VATMatrix.Free;

    CloseTransaction;
    // Maybe need to tell the main daybook whether it needs to refresh
    // i.e. header details have, currently doing a list refresh
    SendMessage((Owner as TForm).Handle, WM_CustGetRec, EBUS_FORM_CLOSE, FORM_TRANS);
  end;
end;


//-----------------------------------------------------------------------

procedure TfrmOneTransaction.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CloseForm(BOff);
  Action := caFree;
end;

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.FormDestroy(Sender: TObject);
begin
//  CloseForm(BOn);  We can't call this here as a close by the parent form causes a GPF.
  if Assigned(NotesCtrl) then
   FreeAndNil(NotesCtrl);
  FreeAndNIL(TTDHelper);
end;

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.mniSaveOnExitClick(Sender: TObject);
begin
  FormStuff.bStoreCoord := not FormStuff.bStoreCoord;
end;

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.mniPropertiesClick(Sender: TObject);
begin
  with FormStuff do
    ListProperties(Self, aMULCtrlO[0], bSetDefaults, 'EBusiness Daybook Properties');
end;

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.WMSysCommand(var Message : TMessage);
// Notes : Prevent the form from maximising when the maximise title bar
//         button is clicked.  Standard Enterprise behaviour for an MDI child.
begin
  with Message do
    case WParam of
      SC_Maximize :
        begin
          Self.ClientHeight := DEF_CLIENT_HEIGHT;
          Self.ClientWidth := DEF_CLIENT_WIDTH;
          WParam := 0;
        end;
    end; // case
  inherited;
end;

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo);
begin
  with Message.MinMaxInfo^ do
  begin
    ptMinTrackSize.X := DEF_CLIENT_WIDTH + 8;
    ptMinTrackSize.Y := DEF_CLIENT_HEIGHT + 27;
  end;
  Message.Result := 0;
  Inherited;
end; // TfrmCompanies.WMGetMinMaxInfo

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.HeadersMouseDownExecute(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  {depresses the column header}
  if (Sender is TSBSPanel) and (not TSBSPanel(Sender).ReadytoDrag) and (Button = MBLeft)
  then FormStuff.aMULCtrlO[0].VisiList.PrimeMove(Sender); {begin column drag/drop}
end;

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.HeadersMouseMoveExecute(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  {visually moves column header to show the change about to be made (drag/drop}
  if (Sender is TSBSPanel) then FormStuff.aMULCtrlO[0].VisiList.MoveLabel(X,Y);
end;

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.MoveAlignColsExecute(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Sender is TSBSPanel) then DoMoveAlignCols(TSBSPanel(Sender), FormStuff, 0);
end;

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.FormCreate(Sender: TObject);
var
  Status : integer;
begin
    with TEBusBtrieveCompany.Create(true) do
    try
      CompanyCode := CurCompSettings.CompanyCode;
      OpenFile;
      if FindRecord = 0 then
        YrRefToAltRef := CompanySettings.CompYourRefToAltRef
      else
        YrRefToAltRef := False;
    finally
      Free;
    end;

  FillChar(EntryRec^.Access, 512, 1);
  fDoingClose:=BOff;

  fExLocalTransHead := nil;
  // Create(2) when Notes processing functionality available
  FormStuff := TFormStuff.Create(2);

  ClientHeight := DEF_CLIENT_HEIGHT;
  ClientWidth := DEF_CLIENT_WIDTH;

  with FormStuff do
  begin
    bFillList := true;
    SetLength(aColumns[0], 7);
    // Stock code
    aColumns[0,0].ColPanel := pnlStk;
    aColumns[0,0].HeadPanel := pnlStkHead;
    // Quantity
    aColumns[0,1].ColPanel := pnlQty;
    aColumns[0,1].HeadPanel := pnlQtyHead;
    aColumns[0,1].Alignment := taRightJustify;
    aColumns[0,1].DecPlaces := CurCompSettings.QuantityDP;
    // Description
    aColumns[0,2].ColPanel := pnlDesc;
    aColumns[0,2].HeadPanel := pnlDescHead;
    // Line Total
    aColumns[0,3].ColPanel := pnlLT;
    aColumns[0,3].HeadPanel := pnlLTHead;
    aColumns[0,3].Alignment := taRightJustify;
    aColumns[0,3].DecPlaces := 2;
    // VAT code
    aColumns[0,4].ColPanel := pnlVAT;
    aColumns[0,4].HeadPanel := pnlVATHead;
    // Unit price
    aColumns[0,5].ColPanel := pnlUPrc;
    aColumns[0,5].HeadPanel := pnlUPrcHead;
    aColumns[0,5].Alignment := taRightJustify;
    aColumns[0,5].DecPlaces := CurCompSettings.PriceDP;
    // Discount
    aColumns[0,6].ColPanel := pnlDisc;
    aColumns[0,6].HeadPanel := pnlDiscHead;

    aFileNos[0] := IDetailF;
    asbMain[0] := sbxMain;
    apanTitle[0] := pnlColumnHeaders;
    asbButtons[0] := sbxButtons;
    apanButtons[0] := pnlButtons;
    aMULCtrlO[0] := TEBusLinesList.Create(Self);
    apanScrollBar[0] := pnlListControls;
    aiKeys[0] := 0;
    aKeyStart[0] := FullNomKey(Inv.FolioNum);
    aUseSet4End[0]:=BOn;

    SetLength(aColumns[1], 3);
    // Stock code
    aColumns[1,0].ColPanel := NDatePanel;
    aColumns[1,0].HeadPanel := NDateLab;
    // Quantity
    aColumns[1,1].ColPanel := NDescPanel;
    aColumns[1,1].HeadPanel := NDescLab;
    // Description
    aColumns[1,2].ColPanel := NUserPanel;
    aColumns[1,2].HeadPanel := NUserLab;

    asbMain[1] := TCNScrollBox;
    apanTitle[1] := TNHedPanel;
    asbButtons[1] := sbxButtons;
    apanButtons[1] := pnlButtons;


    sbxMain.HorzScrollBar.Position := 0;
    sbxMain.VertScrollBar.Position := 0;
    ReadFormProperties(Self, FormStuff, BASE_FORM_LETTER);
    DoFormResize(Self, FormStuff);

    InitialFormSetup;
    SetLineTypeCaptions;

    TTDHelper := TTTDTransactionHelper.Create;


  end;
end;

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.InitialFormSetup;
// Notes : Set-up of form dependant on company set-up
begin
  pgcOneTransaction.ActivePage := tabMain;
  // Notes processing functionality not currently available
//  tabNotes.TabVisible := false;

  // Whether to show cost centres, departments and locations at bottom of form
  edtCCCode.Visible := CurCompSettings.CCDepEnabled;
  lblCC.Visible := CurCompSettings.CCDepEnabled;
  edtDepCode.Visible := CurCompSettings.CCDepEnabled;
  lblDept.Visible := CurCompSettings.CCDepEnabled;
  edtLocCode.Visible := CurCompSettings.MultiLocEnabled;
  lblLocation.Visible := CurCompSettings.MultiLocEnabled;

  // Whether to show controls on the footer page
  pnlIntrastat.Visible := Syss.Intrastat;

  // Only needs to be done when form created
  AssignCurrencyItems(cbxCurrency.Items, false);
  AssignCurrencyItems(cbxCurrency.ItemsL, true);


    {* Build VAT Matrix *}
  VATMatrix:=TVATMatrix.Create;

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

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.FormResize(Sender: TObject);
begin
  DoFormResize(Self, FormStuff);
end;

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.btnCloseClick(Sender: TObject);
begin
  if HeaderChanged then
  begin
    case MessageDlg(Format('Save changes to %s - %s',
      [GetEBusDocName(copy(fExLocalTransHead^.LInv.OurRef, 1, 3)),
      fExLocalTransHead^.LInv.OurRef]), mtConfirmation, [mbYes, mbNo, mbCancel], 0) of
      mrYes :
        begin
          SaveHeader;
          Close;
        end;
      mrNo :
        Close;
      // Pressing cancel in Enterprise ensures that the user is not queried
      // abbout saving changes on clicking 'Close', unless more changes are made
      mrCancel :
        HeaderChanged := false;
    end; // case
  end
  else // No edits to the header
    Close;
end;

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

//-----------------------------------------------------------------------

 procedure TfrmOneTransaction.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
end;

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.WMFormCloseMsg(var Message: TMessage);
begin
  // Avoids problem with coordination between parent and child form refresh
  with Message do
    case WParam of
      1001 : TransactionLineUpdated;  
    end;
end;

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.TransactionLineUpdated;
// Notes : Called when the user moves between lines in the transaction lines Btrieve list
begin
  with ID do
  begin
    edtCCCode.Text := CCDep[true];   // CC
    edtDepCode.Text := CCDep[false]; // Dept
    edtLocCode.Text := MLocStk;
    edtGLCodeDesc.Text := GetNomDescription(NomCode);
  end;
end; // TfrmOneTransaction.TransactionLineUpdated

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.RefreshTraderAddress(CCode  :  Str10);

Var
  TraderDetails : TBatchCURec;
  i : integer;

Begin

    memAddress.Clear;
    if GetTraderDetailsFromCode(CCode, TraderDetails) = 0 then
    begin
      memAddress.Text := Trim(TraderDetails.Company);
      for i := 1 to 5 do
        if Trim(TraderDetails.Addr[i]) <> '' then
          memAddress.Text := memAddress.Text + CRLF + TraderDetails.Addr[i];
    end;

end;

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.RefreshTransHeader;
var
  TraderDetails : TBatchCURec;
  i : integer;
  CaptionStr : string;
  CurrDiscTaken : boolean;
  Tot1, Tot2, Tot3 : Double;
begin
  with fExLocalTransHead^, LInv do
  begin
    // Form caption
    Caption := Format('E-Business %s Record - %s',[GetEBusDocName(copy(OurRef, 1, 3)), OurRef]);

    // Top of form
    edtACCode.Text := CustCode;

    RefreshTraderAddress(CustCode);

    edtTransDate.DateValue := TransDate;
    edtDueDate.DateValue := DueDate;
    edtPeriod.EPeriod := AcPr;
    edtPeriod.EYear := AcYr;
    edtYourRef.Text := YourRef;
    if YrRefToAltRef then
      edtAltRef.Text := OpName
    else
    begin
      edtAltRef.Text := OurRef;
      edtAltRef.Enabled := False;
    end;
    edtOurRef.Text := OurRef;
    // Item index 0 = currency 1
    cbxCurrency.ItemIndex := Currency -1;
    edtExchRate.Value := CXRate[true];
    chkFixedRate.Checked := SOPKeepRate;

    // Bottom of form
    lblCurrency.Caption := GetCurrencySymbol(Currency);
    edtNetTotal.Value := Round_Up(ITotal(LInv) - InvVat, 2);
    edtVATContent.Value := InvVAT;
    edtGrossTotal.Value := ITotal(LInv);

    // Footer tab
    chkVATAmended.Checked := ManVAT;
    if CtrlNom <> 0 then
      edtControlNom.Text := IntToStr(CtrlNom);

{    edtLineType1.Value := DocLSplit[1];
    edtLineType2.Value := DocLSplit[2];
    edtLineType3.Value := DocLSplit[3];
    edtLineType4.Value := DocLSplit[4];}

    edtSettleDiscPercent.Value := Pcnt2Full(DiscSetl);
    edtSettleDiscDays.Value := DiscDays;
    chkSettleDiscTaken.Checked := DiscTaken;
    edtNoSettleNet.Value := InvNetVal;
    edtSettleNet.Value := InvNetVal;
    edtNoSettleVAT.Value := InvVAT;
    edtSettleVAT.Value := InvVAT;
    edtNoSettleDisc.Value := DiscAmount;
    edtSettleDisc.Value := DiscAmount + DiscSetAm;
    CurrDiscTaken := DiscTaken;
    DiscTaken := false;
    edtNoSettleTotal.Value := ITotal(LInv);
    DiscTaken := true;
    edtSettleTotal.Value := ITotal(LInv);
    DiscTaken := CurrDiscTaken;


    lvTransactionTotals.Clear;
    With lvTransactionTotals.Items.Add Do
    Begin
      Caption := 'Net';

      Tot1 := Round_Up(InvNetVal - DiscAmount, 2);
      SubItems.Add(FormatFloat(GenRealMask, Tot1));

      Tot2 := Round_Up(thPPDGoodsValue, 2);
      SubItems.Add(FormatFloat(GenRealMask, Tot2));

      Tot3 := Round_Up(Tot1 - thPPDGoodsValue, 2);
      SubItems.Add(FormatFloat(GenRealMask, Tot3));
    End; // With lvTransactionTotals.Items.Add
    With lvTransactionTotals.Items.Add Do
    Begin
      Caption := CCVATName^;

      Tot1 := Round_Up(Tot1 + InvVAT, 2);
      SubItems.Add(FormatFloat(GenRealMask, InvVAT));

      Tot2 := Round_Up(Tot2 + thPPDVATValue, 2);
      SubItems.Add(FormatFloat(GenRealMask, thPPDVATValue));

      Tot3 := Round_Up(Tot3 + (InvVAT - thPPDVATValue), 2);
      SubItems.Add(FormatFloat(GenRealMask, Round_Up(InvVAT - thPPDVATValue, 2)));
    End; // With lvTransactionTotals.Items.Add
    With lvTransactionTotals.Items.Add Do
    Begin
      Caption := 'Total';
      SubItems.Add(FormatFloat(GenRealMask, Tot1));
      SubItems.Add(FormatFloat(GenRealMask, Tot2));
      SubItems.Add(FormatFloat(GenRealMask, Tot3));
    End; // With lvTransactionTotals.Items.Add

    // MH 20/03/2015 v7.0.14 ABSEXCH-16284: Update Look and feel of Line Type Totals
    lvLineTypeTotals.Clear;
    With lvLineTypeTotals.Items.Add Do
    Begin
      Caption := 'Type: ' + Trim(FLineTypeCaptions[1]);
      SubItems.Add(FormatFloat(GenRealMask, DocLSplit[1]));
    End; // With lvLineTypeTotals.Items.Add
    With lvLineTypeTotals.Items.Add Do
    Begin
      Caption := 'Type: ' + Trim(FLineTypeCaptions[2]);
      SubItems.Add(FormatFloat(GenRealMask, DocLSplit[2]));
    End; // With lvLineTypeTotals.Items.Add
    With lvLineTypeTotals.Items.Add Do
    Begin
      Caption := 'Type: ' + Trim(FLineTypeCaptions[3]);
      SubItems.Add(FormatFloat(GenRealMask, DocLSplit[3]));
    End; // With lvLineTypeTotals.Items.Add
    With lvLineTypeTotals.Items.Add Do
    Begin
      Caption := 'Type: ' + Trim(FLineTypeCaptions[4]);
      SubItems.Add(FormatFloat(GenRealMask, DocLSplit[4]));
    End; // With lvLineTypeTotals.Items.Add
    With lvLineTypeTotals.Items.Add Do
    Begin
      Caption := 'Line Discount';
      SubItems.Add(FormatFloat(GenRealMask, DiscAmount));
    End; // With lvLineTypeTotals.Items.Add

    //PR 15/06/2015 v7.0.14 Prompt Payment Discount fields
    ccyPPDPercentage.Value := Pcnt2Full(thPPDPercentage);
    ccyPPDDays.Value := thPPDDays;
    UpdatePPDStatusInfo;

  end;
end;

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.RefreshVATAnalysis;
// Notes : Updates the VAT analysis display from the VAT analysis data structure

Var
   v : VATType;
  
Begin
  If (VATMatrix<>nil) then
  With VATMatrix do
  Begin
    HideVATMatrix(fVATRateUsed);

    For v:=VStart to VEnd do
    Begin
      IdRec(Ord(v))^.GoodsD.Value:=fVATGoods[v];
      IdRec(Ord(v))^.VATD.Value:=fExLocalTransHead^.LInv.InvVATAnal[v];
    end;
  end;
  
end;

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.btnDeliveryClick(Sender: TObject);

  procedure UpdateDelLine(var DelLine : str30; const NewLine : string);
  begin
    if DelLine <> NewLine then
    begin
      DelLine := NewLine;
      HeaderChanged := true;
    end;
  end;

begin
  with TfrmDelAddress.Create(self) do
  try
    // Assign font and colour from control on header of transaction screen
    SetFormProperties(memAddress.Font, memAddress.Color);
    if EditMode = actEdit then
      EnableEditing;
    //PR: 16/10/2013 ABSEXCH-14703 Include postcode parameter
    //PR: 30/08/2016 ABSEXCH-17138 Include country code
    SetAddressDetails(fExLocalTransHead^.LInv.DAddr, fExLocalTransHead^.LInv.thDeliveryPostcode, fExLocalTransHead^.LInv.thDeliveryCountry);
    if ShowModal = mrOK then
    begin
      UpdateDelLine(fExLocalTransHead^.LInv.DAddr[1], edtDelivery1.Text);
      UpdateDelLine(fExLocalTransHead^.LInv.DAddr[2], edtDelivery2.Text);
      UpdateDelLine(fExLocalTransHead^.LInv.DAddr[3], edtDelivery3.Text);
      UpdateDelLine(fExLocalTransHead^.LInv.DAddr[4], edtDelivery4.Text);
      UpdateDelLine(fExLocalTransHead^.LInv.DAddr[5], edtDelivery5.Text);

      //PR: 16/10/2013 ABSEXCH-14703 Set delivery postcode
      fExLocalTransHead^.LInv.thDeliveryPostcode := edtPostcode.Text;

      //PR: 30/08/2016 ABSEXCH-17138 Include country code
      fExLocalTransHead^.LInv.thDeliveryCountry := ISO3166CountryCodes.ccCountryDetails[lstCountry.ItemIndex].cdCountryCode2;
    end;
  finally
    Free;
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.actAddLineExecute(Sender: TObject);
begin
  Case pgcOneTransaction.ActivePageIndex of
    0 : ShowLineDetailsForm(actAdd);
    2 : NotesCtrl.AddEditNote(False, False);
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.actEditLineExecute(Sender: TObject);
begin
  Case pgcOneTransaction.ActivePageIndex of
    0 : ShowLineDetailsForm(EditMode);
    2 : NotesCtrl.AddEditNote(True, False);
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.btnInsertClick(Sender: TObject);
begin
  Case pgcOneTransaction.ActivePageIndex of
    0 : ShowLineDetailsForm(actInsert);
    2 : NotesCtrl.AddEditNote(False, True);
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.actDeleteLineExecute(Sender: TObject);
begin
  if pgcOneTransaction.ActivePageIndex = 0 then
  with FormStuff.aMulCtrlO[0] do
  begin
    if ConfirmRecordDelete('this Line') then
    begin
      GetSelRec(false);
      Delete_Rec(F[IDetailF], IDetailF, 0);
      DeletePreserveLine(Inv.OurRef, Id.LineNo);
      {InvFSu3U.}UpdateRecBal(Id,fExLocalTransHead^.LInv,BOn,BOn,0);

      UpdateDisplay;
      MustBeSaved;

      If (Id.sdbFolio<>0) then
        Delete_Kit(Id.sdbFolio,0,fExLocalTransHead^.LInv);

      PageUpDn(0,BOn);

      If (PageKeys^[0]=0) then {* Update screen as we have lost them all!*}
        InitPage
      else
        ValidLine;


      SetListFocus;
    end;
  end
  else
  begin
    NotesCtrl.DeleteNoteLine;
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.MustBeSaved;
// Notes : Transaction must be saved as the lines have been edited
begin
  btnClose.Enabled := false;
  btnCancel.Enabled := false;
  btnCloseFooter.Enabled := false;
  btnCancelFooter.Enabled := false;
end;

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.btnOKClick(Sender: TObject);
begin
  SaveHeader;
  Close;
end;

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.CloseTransaction;
begin
  with fExLocalTransHead^ do
  begin
    if EditMode = actEdit then
      UnLockMLock(InvF, 0);
    CloseSelFiles([InvF]);
  end;
  dispose(fExLocalTransHead, destroy);
end;

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.ReadTransaction;
var
  KeyS : str255;
  LockType : integer;
  Locked,
  ReadOK : boolean;
begin
  new(fExLocalTransHead, Create(CLIENT_ID_HEADER));
  with fExLocalTransHead^ do
  begin
    OpenOneFile(InvF, CurCompSettings.CompanyPath, EBUS_DOCNAME);
    OpenOneFile(PWrdF, CurCompSettings.CompanyPath, EBUS_NOTESNAME);
    KeyS := Inv.OurRef;
    UsePrompt := true;

    if EditMode = actEdit then
    begin
      ReadOK := LGetMultiRec(B_GetEq, B_MultLock, KeyS, 2, InvF, false, Locked);
      if ReadOK then
        if Locked then
          EnableEditing
        else
          EditMode := actShow;
    end
    else
      ReadOK := LFind_Rec(B_GetEq, InvF, 2, KeyS) = 0;

    if ReadOK then
    begin
      UpdateDisplay;
      CheckTraderDependencies;
    end
    else ; // Couldn't read transaction - raise exception ?
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.Form2Inv;

Var
  n  :  VATType;

Begin


  With fExLocalTransHead^,LInv do
  Begin
    ManVAT:=ChkVATamended.Checked;

    If (ManVAT) then
      For n:=VStart to VEnd do
      Begin
        InvVATAnal[n]:=VATMatrix.IDRec(Ord(n))^.VATD.Value;

      end;

    //PR: 01/04/2015 Add handling for Settlement Discount/PPD
    if nbSettleDisc.PageIndex = SettleDiscPage then
    begin
      DiscSetl := Pcnt(edtSettleDiscPercent.Value);
      DiscDays := Round(edtSettleDisc.Value);
      DiscTaken:= chkSettleDiscTaken.Checked;

      thPPDPercentage := 0.0;
      thPPDDays       := 0;
      thPPDTaken      := ptPPDNotTaken;
    end // if nbSettleDisc.PageIndex = SettleDiscPage
    else
    begin
      shapePPDStatus.Visible := lblPromptPaymentDiscountHeader.Visible And (Inv.InvDocHed In [SIN, PIN]);
      lblPPDStatus.Visible := shapePPDStatus.Visible;
      // Prompt Payment Discount
      thPPDPercentage := Pcnt(ccyPPDPercentage.Value);
      thPPDDays       := Round(ccyPPDDays.Value);
      UpdatePPDStatusInfo;

      DiscSetl := 0.0;
      DiscDays := 0;
      DiscTaken:= False;
    end;

    //PR: 01/02/2016 ABSEXCH-17116 v2016 R1 Put intrastat values back in Inv record
    if pnlIntrastat.Visible then
    begin
      FormIntrastatToTrans;
    end;


  end;
end;

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.SaveHeader;
var
  Status : integer;
begin
  Form2Inv;

  CalcHeaderTotals;


  with fExLocalTransHead^ do
  begin


    Status := LPut_Rec(InvF, 2);
    if Status <> 0 then
      Report_BError(InvF, Status);
  end;
  TTDHelper.ApplyDiscounts (Self, edtAcCode, fExLocalTransHead.LInv);
end;

//-----------------------------------------------------------------------

(*
procedure TfrmOneTransaction.SaveHeader;
begin
  with fExLocalTransHead^, LInv do
  begin
//    CustCode := edtACCode.Text;
//    TransDate := edtTransDate.DateValue;
//    DueDate := edtDueDate.DateValue;
//    AcPr := edtPeriod.EPeriod;
//    AcYr := edtPeriod.EYear;
//    YourRef := edtYourRef.Text;
//    TransDesc := edtAltRef.Text;
    OurRef := edtOurRef.Text;
    // Item index 0 = currency 1
//    Currency := cbxCurrency.ItemIndex +1;

    InvVAT := edtVATContent.Value;
    DocLSplit[1] := edtLineType1.Value;
    DocLSplit[2] := edtLineType2.Value;
    DocLSplit[3] := edtLineType3.Value;
    DocLSplit[4] := edtLineType4.Value;

    DiscSetl := edtSettleDiscPercent.Value;
    DiscDays := trunc(edtSettleDiscDays.Value);
    DiscTaken := chkSettleDiscTaken.Checked;
    InvNetVal := edtNoSettleNet.Value;
    DiscAmount := edtNoSettleDisc.Value;
    edtSettleDisc.Value := DiscAmount + DiscSetAm;
  end;
end; *)

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.RecalculateHeaderFromLines;
var
  ExLocal : ^TExLocalEBus;
  CurrentLineCount : integer;
begin
  new(ExLocal, Create(CLIENT_ID_LOCAL));
  ExLocal^.ShowErrors := true;
  ExLocal^.OpenOneFile(IDetailF, CurCompSettings.CompanyPath, EBUS_DETAILNAME);
  CurrentLineCount := fExLocalTransHead^.LInv.ILineCount;
  LCalcInvTotals(fExLocalTransHead^.LInv, ExLocal, true, true);
  // Reset the line count which has been changed by call to LCalcInvTotals
  fExLocalTransHead^.LInv.ILineCount := CurrentLineCount;
  ExLocal^.CloseSelFiles([IDetailF]);
  dispose(ExLocal, destroy);
end;

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.EnableEditing;
begin
  // Data Entry tab
  edtACCode.ReadOnly := false;
  edtTransDate.ReadOnly := false;
  edtDueDate.ReadOnly := false;
  edtPeriod.ReadOnly := false;
  edtYourRef.ReadOnly := false;
  edtAltRef.ReadOnly := false;
  cbxCurrency.ReadOnly := false;
  ExchangeRateEnabled;
  chkFixedRate.Enabled := true;

  // Footer tab
  EnableVATEditing;
  chkVATAmended.Enabled := true;
  edtSettleDiscPercent.ReadOnly := false;
  edtSettleDiscDays.ReadOnly := false;
  chkSettleDiscTaken.Enabled := true;

  ccyPPDPercentage.ReadOnly := false;
  ccyPPDDays.ReadOnly := false;
end;

//-----------------------------------------------------------------------

function TfrmOneTransaction.CancellingEdits : boolean;
begin
  Result := (ActiveControl = btnCancel) or (ActiveControl = btnCancelFooter);
end;

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.edtACCodeExit(Sender: TObject);
var
  ACCode : string20;
  TraderType : TTraderType;
begin
  if not CancellingEdits and (EditMode <> actShow) then
  begin
    if IsPurchaseTransaction(fExLocalTransHead^.LInv.OurRef) then
      TraderType := trdSupplier
    else
      TraderType := trdCustomer;

    edtACCode.Text := Trim(edtACCode.Text);
    ACCode := edtACCode.Text;
    if DoGetCust(self, CurCompSettings.CompanyPath, ACCode, ACCode, TraderType,
                   vmShowList, true) then
    begin
      if fExLocalTransHead^.LInv.CustCode <> ACCode then
      begin
        fExLocalTransHead^.LInv.CustCode := ACCode;
        HeaderChanged := true;
        edtACCode.Text := ACCode;

        RefreshTraderAddress(ACCode);
      end;
    end;
  end;
  CheckTraderDependencies;
end;

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.cbxCurrencyExit(Sender: TObject);
var
  CurrNum : integer;
  CurrRec : TBatchCurrRec;
begin
  if not CancellingEdits and (EditMode <> actShow) then
  begin
    CurrNum := cbxCurrency.ItemIndex +1;
    if fExLocalTransHead^.LInv.Currency <> CurrNum then
    begin
      fExLocalTransHead^.LInv.Currency := CurrNum;
      fHeaderChanged := true;

      lblCurrency.Caption := GetCurrencySymbol(CurrNum);
      FillChar(CurrRec, SizeOf(CurrRec), 0);

      if Ex_GetCurrency(@CurrRec, Sizeof(CurrRec), CurrNum) = 0 then
      begin
        if CurCompSettings.DailyRate then
          edtExchRate.Value := CurrRec.DailyRate
        else
          edtExchRate.Value := CurrRec.CompanyRate;

        fExLocalTransHead^.LInv.CXRate[true] := edtExchRate.Value;
        fExLocalTransHead^.LInv.CXRate[false] := edtExchRate.Value;

        ExchangeRateEnabled;
      end;
    end;
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.edtTransDateExit(Sender: TObject);
begin
  if not CancellingEdits and (EditMode <> actShow) and
    (fExLocalTransHead^.LInv.TransDate <> edtTransDate.DateValue) then
  begin
    fExLocalTransHead^.LInv.TransDate := edtTransDate.DateValue;
    HeaderChanged := true;

    ShowSettlementDiscountFields;
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.edtDueDateExit(Sender: TObject);
begin
  if not CancellingEdits and (EditMode <> actShow) and
    (fExLocalTransHead^.LInv.DueDate <> edtDueDate.DateValue) then
  begin
    fExLocalTransHead^.LInv.DueDate := edtDueDate.DateValue;
    HeaderChanged := true;
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.edtPeriodExit(Sender: TObject);
begin
  if not CancellingEdits and (EditMode <> actShow) and
    (fExLocalTransHead^.LInv.AcPr <> edtPeriod.EPeriod) then
  begin
    fExLocalTransHead^.LInv.AcPr := edtPeriod.EPeriod;
    HeaderChanged := true;
  end;
  if fExLocalTransHead^.LInv.AcYr <> edtPeriod.EYear then
  begin
    fExLocalTransHead^.LInv.AcYr := edtPeriod.EYear;
    HeaderChanged := true;
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.edtYourRefExit(Sender: TObject);
begin
  if not CancellingEdits and (EditMode <> actShow) and
    (fExLocalTransHead^.LInv.YourRef <> edtYourRef.Text) then
  begin
    fExLocalTransHead^.LInv.YourRef := edtYourRef.Text;
    HeaderChanged := true;
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.edtAltRefExit(Sender: TObject);
begin
  if not CancellingEdits and (EditMode <> actShow) and
    YrRefToAltRef and
    (fExLocalTransHead^.LInv.OpName <> edtAltRef.Text) then
  begin
    fExLocalTransHead^.LInv.OpName := edtAltRef.Text;
    HeaderChanged := true;
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmOneTransaction.edtExchRateExit(Sender: TObject);
begin
  if not CancellingEdits and (EditMode <> actShow) and
    not ZeroFloat(abs(fExLocalTransHead^.LInv.CXRate[true] - edtExchRate.Value)) then
  begin
    fExLocalTransHead^.LInv.CXRate[true] := edtExchRate.Value;
    fExLocalTransHead^.LInv.CXRate[false] := edtExchRate.Value;
    HeaderChanged := true;
  end;
end;

//----------------------------------------------------------------------

procedure TfrmOneTransaction.chkFixedRateClick(Sender: TObject);
begin
  if not CancellingEdits and (EditMode <> actShow) and
    fExLocalTransHead^.LInv.SOPKeepRate <> chkFixedRate.Checked then
  begin
    fExLocalTransHead^.LInv.SOPKeepRate := chkFixedRate.Checked;
    HeaderChanged := true;
  end;
end;

//----------------------------------------------------------------------

procedure TfrmOneTransaction.ExchangeRateEnabled;
// Notes : Enables the exchange rate field, if possible
//         i.e. currency is NOT triangulated, nor company rate in use
var
  NotEditable : boolean;
  CurrRec : TBatchCurrRec;
begin
  NotEditable := not CurCompSettings.DailyRate;
  FillChar(CurrRec, SizeOf(CurrRec), 0);
  if Ex_GetCurrency(@CurrRec, Sizeof(CurrRec), fExLocalTransHead^.LInv.Currency) = 0 then
    NotEditable := NotEditable or (CurrRec.TriEuro <> 0);
  edtExchRate.ReadOnly := NotEditable;
end;

//----------------------------------------------------------------------

//----------------------------------------------------------------------

procedure TfrmOneTransaction.edtControlNomExit(Sender: TObject);
var
  Validate : boolean;
  ControlNom : longint;
begin
  // Blank should be allowed - don't force the user to have a control nominal
  if Trim(edtControlNom.Text) = '' then
    exit;

  Validate := not CancellingEdits and (EditMode <> actShow);
  try
    ControlNom := StrToInt(Trim(edtControlNom.Text));
  except
    ControlNom := 0;
    Validate := true;
  end;
  Validate := Validate and ((ControlNom <> fExLocalTransHead^.LInv.CtrlNom) and
    (fExLocalTransHead^.LInv.CtrlNom = 0));

  if Validate then
  begin
    if DoGetNom(self, CurCompSettings.CompanyPath, edtControlNom.Text, ControlNom,
                 [nomControl], vmShowList, true) then
(* if DoGetNom(self, CurCompSettings.CompanyPath, edtControlNom.Text, ControlNom,
      [nomControl], true) then *)
    begin
      if fExLocalTransHead^.LInv.CtrlNom <> ControlNom then
      begin
        fExLocalTransHead^.LInv.CtrlNom := ControlNom;
        HeaderChanged := true;
      end;
    end
    else
      edtControlNom.SetFocus;
    // User may have selected the same nominal code via its description, so always
    // need to update the display
    edtControlNom.Text := IntToStr(ControlNom);
  end;
end;

//----------------------------------------------------------------------

function TfrmOneTransaction.TraderControlNomSet(const TraderCode : string) : boolean;
var
  TraderRec : TBatchCURec;
  SearchCode : array[0..255] of char;
begin
  Result := false;
  FillChar(TraderRec, SizeOf(TraderRec), 0);
  StrPCopy(SearchCode, TraderCode);
  if Ex_GetAccount(@TraderRec, SizeOf(TraderRec), SearchCode, 0, B_GetEq, 0, false) = 0 then
    Result := TraderRec.DefCtrlNom <> 0;
end;

//----------------------------------------------------------------------

procedure TfrmOneTransaction.CheckTraderDependencies;
begin
  pnlIntrastat.Visible := Syss.Intrastat and IntraStatAvailable(fExLocalTransHead^.LInv.CustCode);
  ArrangeIntrastatControls;
  PopulateIntrastatLists;


  edtControlNom.ReadOnly := (EditMode = actShow) or not
    TraderControlNomSet(fExLocalTransHead^.LInv.CustCode);
end;


procedure TfrmOneTransaction.chkVATAmendedMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if not CancellingEdits and (EditMode <> actShow) and
    (fExLocalTransHead^.LInv.ManVAT<> ChkVATAmended.Checked) then
  begin
    fExLocalTransHead^.LInv.ManVAT:=ChkVATAmended.Checked;
    HeaderChanged := true;
  end;

end;


procedure TfrmOneTransaction.I5VV1FExit(Sender: TObject);
begin
  VATMatrix.Update_Rate(Sender,fExLocalTransHead^.LInv);
  RefreshTransHeader;
end;




//----------------------------------------------------------------------

procedure TfrmOneTransaction.EnableVATEditing;
var
  i : integer;
begin
  // Loop through all components on VAT scroll box
  for i := 0 to sbxVATAnalysis.ControlCount -1 do
    if sbxVATAnalysis.Controls[i] is TCurrencyEdit then
      (sbxVATAnalysis.Controls[i] as TCurrencyEdit).ReadOnly := false;
end;

//----------------------------------------------------------------------

procedure TfrmOneTransaction.actCancelExecute(Sender: TObject);
begin
  Close;
end;






procedure TfrmOneTransaction.btnSwitchClick(Sender: TObject);
begin
  NotesCtrl.SwitchGenMode;
end;

procedure TfrmOneTransaction.SetLineTypeCaptions;
var
  iPos, iResult : integer;
  BatchSysRec : TBatchSysRec;
begin
  FillChar(BatchSysRec, SizeOf(BatchSysRec), 0);

  iResult := EX_GETSYSDATA(@BatchSysRec, SizeOf(BatchSysRec));
  if iResult = 0 then
    begin
      FLineTypeCaptions[1] := BatchSysRec.TransLineTypeLabel[1];
      FLineTypeCaptions[2] := BatchSysRec.TransLineTypeLabel[2];
      FLineTypeCaptions[3] := BatchSysRec.TransLineTypeLabel[3];
      FLineTypeCaptions[4] := BatchSysRec.TransLineTypeLabel[4];
    end;
end;


procedure TfrmOneTransaction.btnApplyTTDClick(Sender: TObject);
begin
  TTDHelper.ApplyTTD := True;
  //PR: 21/07/2009 Disable TTD button after use.
  btnApplyTTD.Enabled := False;
end;

procedure TfrmOneTransaction.edtSettleDiscPercentExit(Sender: TObject);
begin
  if not CancellingEdits and (EditMode <> actShow) and
    (fExLocalTransHead^.LInv.DiscSetl<> Pcnt(edtSettleDiscPercent.Value)) then
  begin
    fExLocalTransHead^.LInv.DiscSetl:=Pcnt(edtSettleDiscPercent.Value);

    With fExLocalTransHead^ do
      Re_CalcManualVAT(LInv,fExLocalTransHead^,LInv.DiscSetl);

    RefreshTransHeader;

    HeaderChanged := true;
  end;

end;

procedure TfrmOneTransaction.chkSettleDiscTakenMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if not CancellingEdits and (EditMode <> actShow) and
    (fExLocalTransHead^.LInv.DiscTaken<> ChkSettleDiscTaken.Checked) then
  begin
    fExLocalTransHead^.LInv.DiscTaken:=ChkSettleDiscTaken.Checked;
    HeaderChanged := true;
  end;
end;

procedure TfrmOneTransaction.ccyPPDPercentageExit(Sender: TObject);
begin
  if not CancellingEdits and (EditMode <> actShow) and
    (fExLocalTransHead^.LInv.thPPDPercentage<> Pcnt(ccyPPDPercentage.Value)) then
  begin
    fExLocalTransHead^.LInv.thPPDPercentage:=Pcnt(ccyPPDPercentage.Value);

    With fExLocalTransHead^ do
      Re_CalcManualVAT(LInv,fExLocalTransHead^,LInv.thPPDPercentage);

    UpdatePPDTotals(fExLocalTransHead^.LInv);
    RefreshTransHeader;

    HeaderChanged := true;
  end;
end;

procedure TfrmOneTransaction.chkPPDTakenClick(Sender: TObject);
begin
  // disable PPD Percentage / Days if PPD already taken
  ccyPPDPercentage.Enabled := Inv.thPPDTaken = ptPPDNotTaken;
  ccyPPDDays.Enabled := ccyPPDPercentage.Enabled;
end;

procedure TfrmOneTransaction.ShowSettlementDiscountFields;
begin
  if SettlementDiscountSupportedForDate(edtTransDate.DateValue) then
    nbSettleDisc.PageIndex := SettleDiscPage
  else
    nbSettleDisc.PageIndex := PromptPaymentDiscountPage;
end;

procedure TfrmOneTransaction.UpdatePPDStatusInfo;
begin
  With Inv Do
  Begin
    Case thPPDTaken Of
      ptPPDNotTaken          : Begin
                                 // MH 28/05/2015 v7.0.14 ABSEXCH-16468: Zero value SIN showing 'Status: Available'
                                 If (thPPDPercentage <> 0.0) And (thPPDGoodsValue <> 0.0) And (thPPDVATValue <> 0.0) Then
                                 Begin
                                   // Check Transaction's Oustanding Value equals/exceeds the PPD Value
                                   If (CurrencyOS(Inv, True {Round to 2dp}, False {Convert to Base}, False {UseCODay}) >= Round_Up(Inv.thPPDGoodsValue + Inv.thPPDVATValue, 2)) Then
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
end;
//PR: 01/02/2016 ABSEXCH-17116 v2016 R1 Sets Intrastat controls correctly
procedure TfrmOneTransaction.ArrangeIntrastatControls;
begin
  if pnlIntrastat.Visible then
  begin
    if not SystemSetup.Intrastat.isShowDeliveryTerms then
    begin
      if lblDeliveryTerms.Visible then
      begin
        // Hide the Delivery Terms components
        lblDeliveryTerms.Visible := False;
        cbDeliveryTerms.Visible := False;

        // Shuffle all the other controls up to fill in the gap (shuffle them
        // starting from the bottom).
        lblModeOfTransport.Top := lblNoTc.Top;
        cbModeOfTransport.Top  := cbNoTc.Top;

        lblNoTc.Top := lblTransactionType.Top;
        cbNoTc.Top  := cbTransactionType.Top;

        lblTransactionType.Top := lblDeliveryTerms.Top;
        cbTransactionType.Top := cbDeliveryTerms.Top;
      end;

      pnlIntrastat.Height := cbModeOfTransport.Top + cbModeOfTransport.Height;
    end;

    if not SystemSetup.Intrastat.isShowModeOfTransport then
    begin
      // Hide the Mode of Transport components
      lblModeOfTransport.Visible := False;
      cbModeOfTransport.Visible := False;

      pnlIntrastat.Height := cbNotC.Top + cbNotC.Height;
    end;
  end;
end;

//PR: 01/02/2016 ABSEXCH-17116 v2016 R1 Load Intrastat lists
procedure TfrmOneTransaction.PopulateIntrastatLists;
var
  i : integer;
  Line: string;
begin
  cbDeliveryTerms.Items.Clear;
  for i := 0 to IntrastatSettings.DeliveryTermsCount - 1 do
  begin
    Line := IntrastatSettings.DeliveryTerms[i].Code + ' - ' +
            IntrastatSettings.DeliveryTerms[i].Description;
    cbDeliveryTerms.Items.Add(Line);
    cbDeliveryTerms.ItemsL.Add(Line);
  end;

  cbTransactionType.ItemsL.Assign(cbTransactionType.Items);

  cbNoTc.Items.Clear;
  for i := 0 to IntrastatSettings.NatureOfTransactionCodesCount - 1 do
  begin
    Line := IntrastatSettings.NatureOfTransactionCodes[i].Code + ' - ' +
            IntrastatSettings.NatureOfTransactionCodes[i].Description;
    cbNoTc.Items.Add(Line);
    cbNoTc.ItemsL.Add(Line);
  end;

  cbModeOfTransport.Items.Clear;
  for i := 0 to IntrastatSettings.ModesOfTransportCount - 1 do
  begin
    Line := IntrastatSettings.ModesOfTransport[i].Code + ' - ' +
            IntrastatSettings.ModesOfTransport[i].Description;
    cbModeOfTransport.Items.Add(Line);
    cbModeOfTransport.ItemsL.Add(Line);
  end;

  DefaultIntrastat;
  TransIntrastatToForm;
end;
//PR: 01/02/2016 ABSEXCH-17116 v2016 R1 Copy Intrastat fields from transaction to form
procedure TfrmOneTransaction.TransIntrastatToForm;
begin
  with fExLocalTransHead^.LInv do
  begin
    cbDeliveryTerms.ItemIndex := IntrastatSettings.IndexOf(stDeliveryTerms, ifCode, Trim(DelTerms));
    cbModeOfTransport.ItemIndex := IntrastatSettings.IndexOf(stModeOfTransport, ifCode, IntToStr(TransMode));
    cbNoTc.ItemIndex := IntrastatSettings.IndexOf(stNatureOfTransaction, ifCode, IntToStr(TransNat));

    cbTransactionType.ItemIndex := PTtoCB(SSDProcess);
  end;
end;


//PR: 01/02/2016 ABSEXCH-17116 v2016 R1 Copy Intrastat fields from form to transaction
procedure TfrmOneTransaction.FormIntrastatToTrans;

  // CJS 2016-01-12 - ABSEXCH-17100 - Intrastat fields for Transaction Header
  // Returns the 'code' part of a string which consists of a code followed by
  // a description.
  function ExtractCodePart(FromString: string): string;
  var
    SpacePos: Integer;
  begin
    Result := '';
    SpacePos := Pos(' ', FromString);
    if Spacepos > 0 then
      Result := Copy(FromString, 1, SpacePos - 1);
  end;

  // CJS 2016-01-12 - ABSEXCH-17100 - Intrastat fields for Transaction Header
  function ExtractCodeValue(Combo: TSBSComboBox): Integer;
  var
    Code: string;
  begin
    Result := 0;
    Code := ExtractCodePart(Combo.Text);
    if (Code <> '') then
      Result := StrToIntDef(Code, 0);
  end;

begin
  with fExLocalTransHead^.LInv do
  begin
    DelTerms := ExtractCodePart(cbDeliveryTerms.Text);
    TransNat := ExtractCodeValue(cbNoTc);
    TransMode := ExtractCodeValue(cbModeOfTransport);
    SSDProcess := CBtoPT(cbTransactionType.ItemIndex);
  end;
end;

procedure TfrmOneTransaction.DefaultIntrastat;
begin
  with fExLocalTransHead^.LInv do
  begin
    //PR: 08/02/2016 v2016 R1 ABSEXCH-17267 DelTerms may not be used, so check TransNat for trans changed
    if TransNat = 0 then
    begin
      DelTerms := Cust.SSDDelTerms;
      TransMode := Cust.SSDModeTr;
      if CurrentCountry = IECCode then
        TransNat := 1
      else
        TransNat := 10;
    end;
  end;
end;

end.

