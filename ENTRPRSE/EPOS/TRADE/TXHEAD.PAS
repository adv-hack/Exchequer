unit TXHead;

{ nfrewer440 16:28 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, EPOSProc
  , IAeverButton, StdCtrls, ComCtrls, ExtCtrls, StrUtil, VarConst, TXLine, BackGrnd
  , Tender, BTSupU1, GlobVar, LayList, BTKeys1U, FileUtil, ImgList, DLLInc, TXRecs
  , MultiBuyVar, ExWrap1U, mbdLineFrame, TTDCalcTCM, MiscUtil{, CalcVBD};


{$I EXDLLBT.INC}

type
  TFrmTXHeader = class(TForm)
    Label1: TLabel;
    lCostCentre: TLabel;
    lDepartment: TLabel;
    Bar1: TShape;
    edAccountCode: TEdit;
    edCostCentre: TEdit;
    edDepartment: TEdit;
    Label4: TLabel;
    edCustName: TEdit;
    Label5: TLabel;
    Shape2: TShape;
    Label6: TLabel;
    Shape3: TShape;
    edAddress1: TEdit;
    edAddress2: TEdit;
    edAddress3: TEdit;
    edAddress4: TEdit;
    lvLines: TListView;
    btnCancel: TIAeverButton;
    btnTender: TIAeverButton;
    Label9: TLabel;
    edOrderNo: TEdit;
    btnAdd: TIAeverButton;
    btnEdit: TIAeverButton;
    btnDelete: TIAeverButton;
    btnFindTX: TIAeverButton;
    panTotal: TPanel;
    Label7: TLabel;
    lNetTotal: TLabel;
    edAddress5: TEdit;
    btnFindAcc: TIAeverButton;
    btnSettlement: TIAeverButton;
    Panel1: TPanel;
    Label8: TLabel;
    lVATIncTotal: TLabel;
    Panel2: TPanel;
    lVATTotalTit: TLabel;
    lVATTotal: TLabel;
    btnDeposit: TIAeverButton;
    lCompanyName: TLabel;
    btnCreateFrom: TIAeverButton;
    btnRetrieveLayaway: TIAeverButton;
    btnLayaway: TIAeverButton;
    btnReLogin: TIAeverButton;
    btnCustom1: TIAeverButton;
    btnCustom2: TIAeverButton;
    ilTX: TImageList;
    ilOld: TImageList;
    sbMBD: TScrollBox;
    ListBox1: TListBox;
    edPostcode: TEdit;
    Label2: TLabel;
    procedure btnTenderClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnFindTXClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnFindAccClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure edCostCentreExit(Sender: TObject);
    procedure edDepartmentExit(Sender: TObject);
    procedure edAccountCodeExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSettlementClick(Sender: TObject);
    procedure lvLinesDblClick(Sender: TObject);
    procedure btnDepositClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnLayawayClick(Sender: TObject);
    procedure btnRetrieveLayawayClick(Sender: TObject);
    procedure btnReLoginClick(Sender: TObject);
    procedure HOOK_TXHeadCustomButtonClick(Sender: TObject);
    procedure edAddress1Change(Sender: TObject);
    procedure edAddress2Change(Sender: TObject);
    procedure edAddress3Change(Sender: TObject);
    procedure edAddress4Change(Sender: TObject);
    procedure edAddress5Change(Sender: TObject);
    procedure edCustNameChange(Sender: TObject);
    procedure edOrderNoChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure lvLinesChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure edPostcodeChange(Sender: TObject);
  private
    iStockFolio{, iNextListFolioNo} : integer;
    bForceClose, bIgnoreOnExits, bDontAskOnExit, bBarCode : boolean;
    sBarCode : ANSIstring;
    Procedure WMSysCommand(Var Message  :  TMessage); Message WM_SysCommand;
//    procedure FillTXRecFromForm;
    procedure FillFormFromTXRec;
    procedure EnableDisable;
    procedure FillAccountDetails;
//    function AddTXLine(var TheTXLineRec : TTXLineRec; var iInsertIndex : integer
//    ; rPrevQty : real = 0; bExplodeBOMs : boolean = TRUE) : integer;
//    procedure TXLineRecToItem(var TXLineRec : TTXLineRec; TheItem : TListItem);
//    procedure DeleteLines(iStartIndex : integer; DeleteBOMs : boolean = TRUE);
    procedure FocusFirstLine;
    procedure RecalcColWidths;
    procedure ScrollList;
    procedure ClearTX;
    procedure GetTXDetails(bFind : boolean; bReverse : boolean = FALSE);
    function AskLogin : boolean;
    procedure InitialiseForm;
    function CheckAllSerialNumbers : boolean;
    function CheckAllBinNumbers : boolean;
    procedure ApplicationActive(Sender : TObject);
    procedure EntDeActivate(Sender : TObject);
    function DoLayaway : boolean;
    procedure FillDefaults;
//    function GetNextListFolioNo : integer;
//    procedure CustomButtonClick(Sender: TObject; BtnHandlerId : integer);
//    procedure PopulateOtherThingsAboutThisLine(var TheTXRec : TTXRec; var TheTXLineRec : TTXLineRec; iLineNo : integer);
//    procedure RepopulateOtherThingsAboutAllLines(var TheTXRec : TTXRec);
    function NotGoingToOneOfTheButtonsToIgnore : boolean;
    procedure MBDChanged(Sender: TObject);
 public
    procedure UpdateDisplay;
//    procedure RecalcTotals;
//    procedure RecalcAllTXLines(bResetDiscount : Boolean);
//    FrmTender : TFrmTender;
  end;

var
  FrmTXHeader: TFrmTXHeader;
  FrmTender : TFrmTender;

implementation

uses
{$IFDEF TCCU}  // Trade Counter Customisation
  CustIntU, EnterpriseTrade_TLB,
{$ENDIF}
  PIAboutF, EPOSKey, FindAcc, FindTX, EntLkUp, APIUtil, {NeilProc,} UseDLLU
  , IniFiles, JPeg, ETMiscU, TKUtil, SettDisc, EPOSCnst, Deposit, MathUtil
  , CalcPric, NonStock, Login, BtrvU2, GfxUtil, LicUtil, LicRec, SerialPrc
  , MultiBinPrc, Registry, ComObj,

  // MH 26/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount support withdrawn from 01/04/2015
  TransactionHelperU;

{$R *.DFM}

Procedure TFrmTXHeader.WMSysCommand(Var Message  :  TMessage);
Var
  I : SmallInt;
begin
  With Message do begin
    Case WParam of
      CM_DisplayAbout : Begin
        With TfrmAbout.Create(Self) Do begin
          Try
            {$IFDEF TCCU}  // Trade Counter Customisation
              // Add the Plug-Ins into the About dialog
              If (TradeCustomisation.PlugInCount > 0) Then
                For I := 0 To Pred(TradeCustomisation.PlugInCount) Do
                  AddPlugIn (TradeCustomisation.PlugIns[I]);
            {$ENDIF}
            ShowModal;
          Finally
            Free;
          End;
        End;
      End;

      21 : begin
        if Lparam = 13 then begin
          ActiveControl := btnCancel;
{          while ActiveControl <> edAccountCode
          do application.ProcessMessages;}
        end;
      end;
    End; { Case }
  end;

  Inherited;
end;

{TFrmTXHeader}
(*
procedure TFrmTXHeader.FillTXRecFromForm;
begin
  with TXRec do begin
    sCustName := edCustName.Text;
    sOrderNumber := edOrderNo.Text;
    Address[1] := edAddress1.Text;
    Address[2] := edAddress2.Text;
    Address[3] := edAddress3.Text;
    Address[4] := edAddress4.Text;
    Address[5] := edAddress5.Text;
  end;{with}
end;
*)
procedure TFrmTXHeader.FillFormFromTXRec;
begin
  with TXRec, TKTXHeader do begin
    edAccountCode.Text := TKTXHeader.CustCode;
    lCompanyName.Caption := Trim(LCust.Company);
    edCustName.Text := LongYrRef;
    edOrderNo.Text := YourRef;
    edAddress1.Text := DAddr[1];
    edAddress2.Text := DAddr[2];
    edAddress3.Text := DAddr[3];
    edAddress4.Text := DAddr[4];
    edAddress5.Text := DAddr[5];
    edPostcode.Text := TKTXHeader.thDeliveryPostCode;
    edCostCentre.Text := sCostCentre;
    edDepartment.Text := sDepartment;
  end;{with}
end;

procedure TFrmTXHeader.btnTenderClick(Sender: TObject);
var
  bClose : boolean;
  iLine : integer;

  function HOOK_TXBeforeTenderScreen : boolean;
  var
    CurrentLineRec : TTXLineRec;
  begin{HOOK_TXBeforeTenderScreen}
    Result := TRUE;
    {$IFDEF TCCU}  // Trade Counter Customisation
      // Check to see if the event has been enabled by a Plug-In
      If TWincontrol(Sender).Visible And TradeCustomisation.GotEvent(twiTransaction, hpTXBeforeTenderScreen) Then Begin

        if Assigned(lvLines.Selected) then CurrentLineRec := TTXLineInfo(lvLines.Selected.Data).TXLineRec
        else FillChar(CurrentLineRec, SizeOf(CurrentLineRec), #0);

        // Update EventData with current data values
        TradeCustomisation.EventDataO.Assign(Self.Handle, twiTransaction, hpTXBeforeTenderScreen
        , TXRec, lvLines, TKLocationRecord, CurrentLineRec, TKPayLines, Self);

        TradeCustomisation.EventDataO.aBoolResult[1] := TRUE;

        // Execute the Hook Point Event
        TradeCustomisation.ExecuteEvent;

        // Check the Plug-In changed something
        with TradeCustomisation.EventDataO do begin
          if DataChanged Then Begin
            // Update with changes
            TXRec := LTXRec;
            CopyListViewItems(LListView.Items, lvLines.Items);
//            RecalcAllTXLines(TXRec, lvLines, TRUE);
            if TenderMode = tmAdd then
            begin
              RecalcAllTXLines(TXRec, lvLines, FALSE);
              RecalcTXTotals(TXRec, lvLines);
            end;{if}
            FillFormFromTXRec;
            UpdateDisplay;
          end;{if}

          // Set Result to aBoolResult[1] - Do we allow the tender process to continue
          Result := TradeCustomisation.EventDataO.aBoolResult[1];
        end;{with}
      end; { If TradeCustomisation.GotEvent... }
    {$ENDIF}
  end;{HOOK_TXBeforeTenderScreen}

  // v6.40.311
  // https://jira.iris.co.uk/browse/ABSEXCH-7881
  function StockLevelsOK : boolean;
  var
    iLine : integer;
    bContinue : boolean;
    sLineError : string;
    TXLineInfo : TTXLineInfo;
  begin{StockLevelsOK}
    Result := TRUE;

    // Only Check if we are creating SINs/SRIs or Picked SORs
//    if SetupRecord.TransactionType in [TX_SINs, TX_PICKED_SORs]
//    then begin
    with LvLines do
    begin
      // Check all lines
      For iLine := 0 to Items.Count - 1 do
      begin
        // Do Stock Check
        TXLineInfo := TTXLineInfo(LvLines.Items[iLine].Data);
        TXLineInfo.RefreshStockLevels;
        if not CheckStock(TXLineInfo.TXLineRec.TKStockRec
        ,  TXLineInfo.TXLineRec.TKStockLocRec
        , TXLineInfo.TXLineRec.TKTLRec.Qty) then
        begin
          // Invalid stock level on this line

          // Show Warning
          sLineError := 'Line ' + IntToStr(iLine+1) + ' - '
          + MoneyToStr(TXLineInfo.TXLineRec.TKTLRec.Qty, TKSysRec.QuantityDP) + ' X '
          + TXLineInfo.TXLineRec.TKStockRec.StockCode;
          ShowStockWarning(bContinue, sLineError);
          Result := bContinue;

          // Show Message
//            MyMsgBox('The stock level check on Line ' + IntToStr(iLine+1) + ' has failed.'
//            ,mtWarning,[mbOK],mbOK,'Insufficient Stock');

          // Highlight error line
          lvLines.ItemIndex := iLine;

          // Exit
//            Result := FALSE;
          if not bContinue then break;
        end;
      end;{for}
    end;{with}
//    end;{if}
  end;{StockLevelsOK}

var
  LTXRec : TTXRec;
  CopyOfLines : TListView;
  bTTD : boolean;

begin{btnTenderClick}
  if TWinControl(Sender).Enabled then
  begin
    Screen.cursor := crHourglass;
    ActiveControl := TWinControl(Sender);

    // Disable, so you can;t click on it again
    btnTender.Enabled := FALSE;

//    ActiveControl := btnTender;

    // v6.40.311
    // https://jira.iris.co.uk/browse/ABSEXCH-7881
    // Check that the Stock Levels on all lines are valid
    if not StockLevelsOK then
    begin
      EnableDisable;
      Screen.cursor := crDefault;
      exit;
    end;

    // Check CC & Dept are valid
    if TKSysRec.CCDepts and (SetupRecord.CCDeptMode in [0,2]) then
    begin
      TXRec.sDepartment := Trim(edDepartment.Text);
      TXRec.sCostCentre := Trim(edCostCentre.Text);
      if DoGetCCDep(Self, sCurrCompPath, TXRec.sCostCentre, TXRec.sCostCentre, TRUE, vmCheckValue, TRUE) then
        begin
          if not DoGetCCDep(Self, sCurrCompPath, TXRec.sDepartment, TXRec.sDepartment
          , FALSE, vmCheckValue, TRUE) then begin
            MyMsgBox('You have entered an invalid Department',mtError,[mbOK],mbOK,'Department Error');
            ActiveControl := edDepartment;
            Exit;
          end;{if}
        end
      else begin
        MyMsgBox('You have entered an invalid Cost Centre',mtError,[mbOK],mbOK,'Cost Centre Error');
        ActiveControl := edCostCentre;
        Exit;
      end;{if}
    end;{if}

    // Check That No Selling Prices are too low
    with LvLines do
    begin
      For iLine := 0 to Items.Count - 1 do
      begin
        with TTXLineInfo(Items.Item[iLine].Data).TXLineRec do
        begin
          if bSellingPriceTooLow then
          begin
            MyMsgBox('The selling price is too low for this stock item : ' + Trim(TKStockRec.StockCode)
            + #13#13#9'Cost Price : ' + MoneyToStr(TKStockRec.CostPrice, TKSysRec.CostDP)
            + #13#9'Sales Price : ' + MoneyToStr(rNetPrice, TKSysRec.PriceDP) + #13#9
            ,mtWarning,[mbOK],mbOK,'Selling Price Warning');
            exit;
          end;{if}
        end;{with}
      end;{for}
    end;{with}

    if (SetupRecord.TransactionType <> TX_UNPICKED_SORs) {.200} and (not CheckAllSerialNumbers) then Exit;
    if (SetupRecord.TransactionType <> TX_UNPICKED_SORs) and (not CheckAllBinNumbers) then Exit;

    if HOOK_TXBeforeTenderScreen then
    begin

      // work out Original Net Amount
      Case TenderMode of
        tmAdd :
        begin
          TXRec.rOrigNetTotal := TXRec.rNetTotal;
          RecalcTXTotals(TXRec, lvLines);
//          TXRec.rVATIncTotal := TXRec.rNetTotalAfterDisc + TXRec.TKTXHeader.InvVat;

{          For iLine := 0 to LvLines.items.count-1 do
          begin
            with TTXLineInfo(LvLines.Items.Item[iLine].Data).TXLineRec do
            begin
              rLineOrigNetTotal := rLineNetTotal;
            end;{with}
{          end;{for}
        end;

        tmEdit :
        begin
          LTXRec := TXRec;
          CopyOfLines := TListView.Create(nil);
          CopyOfLines.Visible := FALSE;
          CopyOfLines.Parent := LvLines.Parent;
          CopyListViewItems(LvLines.Items, CopyOfLines.Items);

          // Remove TTD/VBD
          For iLine := 0 to CopyOfLines.items.count-1 do
          begin
            with TTXLineInfo(CopyOfLines.Items.Item[iLine].Data).TXLineRec do
            begin

{              if TXRec.bFindModeTTD then
              begin
                rLineTransDiscount := rLineNetTotal - TTXLineInfo(lvLines.Items.Item[iLine].Data).TXLineRec.rLineNetTotal;
              end else
              begin
                rLineValueDiscount := rLineNetTotal - TTXLineInfo(lvLines.Items.Item[iLine].Data).TXLineRec.rLineNetTotal;
              end;}

              if (TKTLRec.tlTransValueDiscountType > 0) and (TKTLRec.tlTransValueDiscountType < 255)
              then TXRec.bFindModeTTD := TKTLRec.tlTransValueDiscountType = 1;
              rDiscount3 := 0;
              cDiscount3 := #0;
              iDiscount3Type := 0;
              TKTLRec.tlMultiBuyDiscount := 0;
              TKTLRec.tlMultiBuyDiscountChr := #0;
              TKTLRec.tlTransValueDiscount := 0;
              TKTLRec.tlTransValueDiscountChr := #0;
              TKTLRec.tlTransValueDiscountType := 0;
//              rLineOrigNetTotal := rLineNetTotal;
            end;{with}
          end;{for}

          RecalcAllTXLines(LTXRec, CopyOfLines, FALSE);
          LTXRec.rOrigNetTotal := LTXRec.rNetTotal;{.299}
          RecalcTXTotals(LTXRec, CopyOfLines, TRUE);

          TXRec.rNetTotalAfterDisc := LTXRec.rNetTotalAfterDisc;{.299}

          TXRec.rOrigNetTotal := LTXRec.rNetTotal;{.299}
//          TXRec.rVATIncTotal := TXRec.rNetTotalAfterDisc + TXRec.TKTXHeader.InvVat;

          ClearList(CopyOfLines);
          CopyOfLines.Free;

          if TXRec.bFindModeTTD then TXRec.rTTDAmount := LTXRec.rNetTotal - TXRec.rNetTotal
          else TXRec.rVBDAmount := LTXRec.rNetTotal - TXRec.rNetTotal;
//          else
        end;
      end;{case}

      FrmTender := TFrmTender.Create(Self);
      with TFrmTender.Create(Self), TXRec do begin
        try
          PopulateForm(TXRec);

          if TButton(Sender).Caption = 'On Account'
          then DepositMode := fmOnAccount;
          (*
          if ZeroFloat(rDepositToTake) then rMoneyToBeTaken := rOutstanding
          else rMoneyToBeTaken := rDepositToTake;

          bRefund := rMoneyToBeTaken < 0;

          lNet.Caption := sCurrencySym + ' ' + MoneyToStr(rNetTotal);
          lVAT.Caption := sCurrencySym + ' ' + MoneyToStr(TKTXHeader.InvVat);
          lAmount.Caption := sCurrencySym + ' ' + MoneyToStr(rVATIncTotal);

          lDeposits.Caption := sCurrencySym + ' ' + MoneyToStr(rDepositsTaken);

          // VBD
          if ImplementVBDs(rNetTotal) then
          begin
            lValueDiscount.Caption := sCurrencySym + ' ' + MoneyToStr(rValueDiscount);

            lVBDTit.Caption := '- Current VBD @ ' + sCurrencySym + MoneyToStr(VBDs.rCurrentVBDThreshold) + ' = '
            + VBDs.sCurrentVBD;
            lVBDTit.Visible := Trim(VBDs.sCurrentVBD) <> '';

            lNextVBDTit.Caption := '- Next VBD @ ' + sCurrencySym + MoneyToStr(VBDs.rNextVBDThreshold) + ' = '
            + VBDs.sNextVBD;
            lNextVBDTit.Visible := Trim(VBDs.sNextVBD) <> '';
//          lNextVBD.Caption := '';
            bImplementVBDs := TRUE;
          end else
          begin
            bImplementVBDs := FALSE;
          end;{if}

          lVBD.Enabled := bImplementVBDs;
          lValueDiscount.Enabled := bImplementVBDs;
          lVBDTit.Enabled := bImplementVBDs;
          lNextVBDTit.Enabled := bImplementVBDs;

          lNetAfterDisc.Caption :=sCurrencySym + ' ' + MoneyToStr(rNetTotalAfterDisc);

          if rWrittenOff > 0 then
            begin
              lOutstanding.Caption := sCurrencySym + ' ' + MoneyToStr(rWrittenOff);
              lOS.Caption := 'Written Off';
            end
          else begin
            lOutstanding.Caption := sCurrencySym + ' ' + MoneyToStr(rOutstanding);
          end;{if}

          lToBeTaken.Caption := sCurrencySym + ' ' + MoneyToStr(rDepositToTake);

          lDep2.Visible := not ZeroFloat(rDepositToTake);
          lToBeTaken.Visible := lDep2.Visible;
          shDep.Visible := lDep2.Visible;

//SecondLine.Height := 54 + (Ord(not ZeroFloat(rDepositToTake)) * 31);
//shDiscount.Visible := ZeroFloat(rDepositToTake);
//shDeposit.Visible := not ZeroFloat(rDepositToTake);

          {Settlement Discount}
//          panSettDiscount.Visible := not ZeroFloat(TKTXHeader.DiscSetl) and ((TenderMode = tmAdd) or ((TenderMode <> tmAdd) and TKTXHeader.DiscTaken));
//          btnSettDiscount.Visible := panSettDiscount.Visible;
          btnSettDiscount.enabled := not ZeroFloat(TKTXHeader.DiscSetl) and ((TenderMode = tmAdd) or ((TenderMode <> tmAdd) and TKTXHeader.DiscTaken));
          lSettAmount.enabled := btnSettDiscount.enabled;
          lSettDiscount.visible := btnSettDiscount.enabled;
          lSettDiscount.visible := btnSettDiscount.enabled;
          shSettDisc.visible := btnSettDiscount.enabled;

  //        TKTXHeader.DiscSetAm := Round_Up(rNetTotal * TKTXHeader.DiscSetl, 2);

          lSettAmount.Caption := sCurrencySym + ' ' + MoneyToStr(TKTXHeader.DiscSetAm);

          if TButton(Sender).Caption = 'On Account'
          then DepositMode := fmOnAccount;
          *)

          Screen.cursor := crDefault;

          if ShowModal = mrOK then
          begin

            {Go back to login, or new TX ?}
            bClose := FALSE;
            ClearTX;
            if SetupRecord.AfterTender = atLogin then begin
              bDontAskOnExit := TRUE;
              bClose := TRUE;
            end;{if}

          end;{if}

          // re-enable
        finally
          Screen.cursor := crDefault;
          Release;
        end;{try}
      end;{with}
      btnTender.Enabled := TRUE;
      if bClose then Close;
    end;{if}
  end;{if}
end;

procedure TFrmTXHeader.btnAddClick(Sender: TObject);
var
  bOK : boolean;
  iInsertIndex : integer;
begin
  if TWinControl(Sender).Enabled then ActiveControl := btnAdd;
  if TWinControl(Sender).Enabled then begin
    ActiveControl := btnAdd;
    FrmTXLine := TFrmTXLine.Create(Self);
    with FrmTXLine do begin
      try
        FormMode := fmAdd;
        bOK := FALSE;
        if ShowModal = mrOK then begin
          iInsertIndex := lvLines.Items.Count;
          iStockFolio := TXLineRec.TKStockRec.StockFolio;
          PopulateOtherThingsAboutThisLine(TXRec, TXLineRec, (iInsertIndex + 1) * 2);
          AddTXLine(lvLines, TXLineRec, TXRec, iInsertIndex, iStockFolio);
          UpdateDisplay;
          EnableDisable;
          RecalcColWidths;
          ScrollList;
          bOK := TRUE;
        end;{if}
      finally
        Release;
      end;{try}
    end;{with}
    if bOK and SetupRecord.AutoAddLine then btnAddClick(btnAdd);
  end;{if}
end;

procedure TFrmTXHeader.btnEditClick(Sender: TObject);
var
  iInsertAfter : integer;
  bOK, bScroll, bRefocusEdit : boolean;
  EditedTXLineRec : TTXLineRec;
  rPrevQty : real;
begin
  if TWinControl(Sender).Enabled and (lvLines.Selected <> nil) then begin

    {work out where the focus needs to go back to after the edit}
    if ActiveControl = lvLines then bRefocusEdit := FALSE
    else begin
      bRefocusEdit := TRUE;
      ActiveControl := btnEdit;
    end;

    with lvLines do begin
      FocusFirstLine;

      if Trim(TTXLineInfo(Selected.Data).TXLineRec.TKTLRec.StockCode) = '' then
        begin
          {Non-Stock Item}
          with TFrmNonStockItem.Create(Self) do begin
            try
              FormMode := fmEdit;
              NonStockLineRec := TTXLineInfo(Selected.Data).TXLineRec;{populate NonStockLineRec record from the data in the list}
              bOK := ShowModal = mrOK;
              if bOK then EditedTXLineRec := NonStockLineRec;
            finally
              Release;
            end;{try}
          end;{with}
        end
      else begin
        {Stock Item}
        FrmTXLine := TFrmTXLine.Create(Self);
        with FrmTXLine do begin
          try
            FormMode := fmEdit;
            TXLineRec := TTXLineInfo(Selected.Data).TXLineRec;{populate TXLine record from the data in the list}
            rPrevQty := TTXLineInfo(Selected.Data).TXLineRec.TKTLRec.Qty;

            bOK := ShowModal = mrOK;
            if bOK then EditedTXLineRec := TXLineRec;
          finally
            Release;
          end;{try}
        end;{with}
      end;{if}

      if bOK then begin
        {do I need to scroll after editing item ?}
        bScroll := TopItem.Index = Items.Count - VisibleRowCount;

        {Store position for new item}
        iInsertAfter := Selected.Index;

        // Reset list folio number, so we know to explode the bom if neccessary
        if TTXLineInfo(Selected.Data).TXLineRec.TKTLRec.StockCode <> EditedTXLineRec.TKTLRec.StockCode
        then EditedTXLineRec.iListFolioNo := 0;

        {Delete previous item's lines}
        DeleteLines(lvLines, iInsertAfter, TTXLineInfo(Selected.Data).TXLineRec.TKTLRec.StockCode
        <> EditedTXLineRec.TKTLRec.StockCode);

        // Add new lines
        iStockFolio := EditedTXLineRec.TKStockRec.StockFolio;
        PopulateOtherThingsAboutThisLine(TXRec, EditedTXLineRec, (iInsertAfter + 1) * 2);
        AddTXLine(lvLines, EditedTXLineRec, TXRec, iInsertAfter, iStockFolio, rPrevQty);
        UpdateDisplay;
        EnableDisable;

        {realigns scroll position}
        if bScroll then Scroll(0, 16);

        {set focus back to appropriate control}
        bRefocusEdit := bRefocusEdit and TRUE;
        if bRefocusEdit then btnEdit.SetFocus
        else lvLines.SetFocus;
      end;{if}

    end;{with}
  end;{if}
end;

procedure TFrmTXHeader.btnFindTXClick(Sender: TObject);
var
  bOKed : boolean;
  iAsk, iResult : integer;
begin
  if TWinControl(Sender).Visible and TWinControl(Sender).Enabled then begin
    ActiveControl := TWinControl(Sender);

    if (TWinControl(Sender).Name = 'btnFindTX') then iAsk := mrNo
    else iAsk := MyMsgBox('Do you wish this new transaction to be a reversal of the original ?'
    ,mtConfirmation,[mbYes,mbNo,mbCancel],mbNo,'Create New....',2);

    if iAsk <> mrCancel then begin

      with TFrmFindTX.Create(Self) do begin
        try
          btnListNonTCM.Enabled := (iAsk = mrNo) and aAllowedTo[atFindNonTCMTXs];
          bFind := (TWinControl(Sender).Name = 'btnFindTX');
          if bFind then Caption := 'Find Transaction'
          else Caption := 'Create From...';
          iResult := ShowModal;
          bOKed := iResult in [mrOK, mrYes];
        finally
          Release;
        end;{try}
      end;{with}

      if bOKed then GetTXDetails(TWinControl(Sender).Name = 'btnFindTX', iAsk = mrYes);

      if iResult = mrYes then begin
        TXRec.bNonTCMTX := TRUE;
        TXRec.TKTXHeader.DocUser4 := '';
      end;{if}

    end;{if}

  end;{if}
end;

procedure TFrmTXHeader.FormKeyPress(Sender: TObject; var Key: Char);
var
  iInsertIndex : integer;
  iStatus : smallint;
  TXLineRec : TTXLineRec;

  procedure AddBarCodeStockItem;
  begin
    with TXLineRec, TKStockRec do begin
      TKTLRec.StockCode := StockCode;
      bStockOK := TRUE;
//      sDiscount := '-';
      SetDiscountStr(TXLineRec);
      TKTLRec.Qty := 1;
      FillTXLineRec(TXRec, TXLineRec, TKTLRec.StockCode, 1, TRUE);
      if TXLineRec.bSerial then AskForSerialNumbers(TXLineRec);
      if TXLineRec.TKStockRec.UsesBins then AskForBinNumbers(TXLineRec);
{          begin
        {Show serial numbers screen}
{            with TFrmSerial.Create(application) do begin
          try
            rRequired := Round(ABS(TXLineRec.TKTLRec.Qty)) / WhatIsOne(TXLineRec.TKStockRec);
            sStockCode := TXLineRec.TKTLRec.StockCode;
            bRefund := TXLineRec.TKTLRec.Qty < 0;

            CopySerials(@TXLineRec.SerialNumbers, @TStringList(lstUsed.Items));

            Result := ;
            if Result then CopySerials(@TStringList(lstUsed.Items), @TXLineRec.SerialNumbers);
          finally
            Release;
          end;{try}
{            end;{with}
//          end;
    end;{with}
    CalcStockPrice(TXRec, TXLineRec);

    iInsertIndex := lvLines.Items.Count;
    iStockFolio := TXLineRec.TKStockRec.StockFolio;
    PopulateOtherThingsAboutThisLine(TXRec, TXLineRec, (iInsertIndex + 1) * 2);
    AddTXLine(lvLines, TXLineRec, TXRec, iInsertIndex, iStockFolio);
    UpdateDisplay;
    EnableDisable;
    RecalcColWidths;
    ScrollList;
  end;

begin
  if BarCodeKeyPress(Sender, Key, ActiveControl, Handle, bBarCode, sBarCode, TXRec.bAccountOK) then begin
    {barcode has been completely scanned}

//    FillChar(TXLineRec, SizeOf(TXLineRec),#0);
    InitialiseTXLine(TXLineRec);

    // Changed for {.283} to look for the padded and unpadded bar codes
    sBarCode := FullBarCode(sBarCode);
    iStatus := Ex_GetStock(@TXLineRec.TKStockRec, SizeOf(TXLineRec.TKStockRec), PChar(sBarCode), 8, B_GetEq, FALSE);

    case iStatus of
      0 : begin {found - add item to list}
        AddBarCodeStockItem;

(*        with TXLineRec, TKStockRec do begin
          TKTLRec.StockCode := StockCode;
          bStockOK := TRUE;
          sDiscount := '-';
          TKTLRec.Qty := 1;
          FillTXLineRec(TXRec, TXLineRec, TKTLRec.StockCode, 1, TRUE);
          if TXLineRec.bSerial then AskForSerialNumbers(TXLineRec);
          if TXLineRec.TKStockRec.UsesBins then AskForBinNumbers(TXLineRec);
{          begin
            {Show serial numbers screen}
{            with TFrmSerial.Create(application) do begin
              try
                rRequired := Round(ABS(TXLineRec.TKTLRec.Qty)) / WhatIsOne(TXLineRec.TKStockRec);
                sStockCode := TXLineRec.TKTLRec.StockCode;
                bRefund := TXLineRec.TKTLRec.Qty < 0;

                CopySerials(@TXLineRec.SerialNumbers, @TStringList(lstUsed.Items));

                Result := ;
                if Result then CopySerials(@TStringList(lstUsed.Items), @TXLineRec.SerialNumbers);
              finally
                Release;
              end;{try}
{            end;{with}
//          end;
        end;{with}
        CalcStockPrice(TXRec, TXLineRec);

        iInsertIndex := lvLines.Items.Count;
        iStockFolio := TXLineRec.TKStockRec.StockFolio;
        PopulateOtherThingsAboutThisLine(TXRec, TXLineRec, (iInsertIndex + 1) * 2);
        AddTXLine(TXLineRec, iInsertIndex);
        UpdateDisplay;
        EnableDisable;
        RecalcColWidths;
        ScrollList;*)
      end;

      4,9 : begin {padded barcode not found}

        // look for trimmed bar code (previous versions of Exchequer did not pad the bar code field correctly - naughty eduardo
        sBarCode := Trim(sBarCode);
        iStatus := Ex_GetStock(@TXLineRec.TKStockRec, SizeOf(TXLineRec.TKStockRec), PChar(sBarCode), 8, B_GetEq, FALSE);
        case iStatus of
          0 : begin {found - add item to list}
            AddBarCodeStockItem;
          end;

          4,9 : begin
            MyMsgBox('There is no stock record that matches this barcode : ' + sBarCode,mtInformation
            ,[mbOK],mbOK,'Barcode not found');
          end;

          else ShowTKError('Ex_GetStock', 80, iStatus);

        end;{case}
      end;

      else ShowTKError('Ex_GetStock', 80, iStatus);

    end;{case}
  end;{if}
end;

procedure TFrmTXHeader.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  LocalKey : Word;
begin
  if (not bBarCode) and (Key <> VK_CONTROL) then begin
    EPOSKey.GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
    LocalKey := Key;
    Key := 0;

    {Trap function keys & delete key}
    If (LocalKey In [VK_F1..VK_F12, VK_DELETE]) and (Not (ssAlt In Shift)) then
      begin
        case LocalKey of
//          VK_F1 : Application.HelpCommand(HELP_Finder,0);
          VK_F2 : btnLayawayClick(btnLayaway);
          VK_F3 : btnRetrieveLayawayClick(btnRetrieveLayaway);
          VK_F4 : btnDepositClick(btnDeposit);
          VK_F5 : btnAddClick(btnAdd);
          VK_F6 : btnReLoginClick(btnReLogin);
          VK_F7 : btnEditClick(btnEdit);
          VK_F8 : btnSettlementClick(btnSettlement);
          VK_F9 : if btnTender.enabled then btnTenderClick(btnTender);
          VK_F10 : btnFindAccClick(btnFindAcc);
          VK_F11 : btnFindTXClick(btnCreateFrom);
          VK_F12 : btnFindTXClick(btnFindTX);
          VK_DELETE : begin
            if not (ActiveControl is TEdit) then btnDeleteClick(btnDelete)
            else Key := LocalKey;
          end;
          else Key := LocalKey;
        end;{case}
      end
    else begin
      If (LocalKey In [VK_F1..VK_F2]) and (ssAlt In Shift) then
        begin
          case LocalKey of
            VK_F1 : HOOK_TXHeadCustomButtonClick(btnCustom1);
            VK_F2 : HOOK_TXHeadCustomButtonClick(btnCustom2);
          end;{case}
        end
      else Key := LocalKey;
    end;{if}
  end;{if}
end;

procedure TFrmTXHeader.btnFindAccClick(Sender: TObject);
var
  NewActiveControl : TWinControl;
begin
  if TWinControl(Sender).Enabled then begin
    NewActiveControl := ActiveControl;
    ActiveControl := btnFindAcc;
    with TFrmFindAccount.Create(Self) do begin
      try
        if ShowModal = mrOK then begin
          {Show TX}
          TXRec.TKTXHeader.CustCode := Cust.CustCode;
          TXRec.LCust := Cust;
          { CJS 2013-10-22 - MRD2.5.12 - Trade Counter - Delivery Address Postcode }
          if SetupRecord.GetDelAddrFromCustAddr and (not AddressBlank(AddrTyp(TXRec.LCust.DAddr))) then
          begin
            AddrTyp(TXRec.TKTXHeader.Daddr) := TXRec.LCust.DAddr;
            TXRec.TKTXHeader.thDeliveryPostCode := TXRec.LCust.acDeliveryPostCode;
          end
          else
          begin
            AddrTyp(TXRec.TKTXHeader.Daddr) := TXRec.LCust.Addr;
            TXRec.TKTXHeader.thDeliveryPostCode := TXRec.LCust.PostCode;
          end;
          FillAccountDetails;
        end;{if}
      finally
        Release;
      end;{try}
    end;{with}
    ActiveControl := NewActiveControl;
  end;{if}
end;

procedure TFrmTXHeader.btnDeleteClick(Sender: TObject);
var
  iNewPos : integer;
begin
  if TWinControl(Sender).Enabled and (lvLines.Selected <> nil) then begin
    if ActiveControl <> lvLines then ActiveControl := btnDelete;
    FocusFirstLine;
    if MyMsgBox('Are you sure you wish to delete this item from the transaction ?',mtConfirmation
    ,[mbYes,mbNo],mbNo,'Delete Item') = mrYes then begin
      with lvLines do begin
        {Store new highlight position}
        iNewPos := Selected.Index - 1;

        {Delete lines for item}
        DeleteLines(lvLines, Selected.Index);

        {Highlight item above deleted item}
        if (iNewPos = -1) and (Items.Count > 0) then iNewPos := 0;
        if iNewPos >= 0 then begin
          Selected := Items.Item[iNewPos];
          ItemFocused := Items.Item[iNewPos];
        end;{if}
      end;{with}

      {update display}
      RecalcColWidths;
      RecalcTXTotals(TXRec, lvLines);
      UpdateDisplay;
      EnableDisable;
      if (ActiveControl <> lvLines) and btnDelete.enabled then ActiveControl := btnDelete;
    end;{if}
  end;{if}
end;

procedure TFrmTXHeader.edCostCentreExit(Sender: TObject);
begin
  if not bIgnoreOnExits then begin
    TXRec.sCostCentre := edCostCentre.Text;
{    if (ActiveControl <> btnCancel) and (ActiveControl <> nil)
    and (ActiveControl <> btnCustom1) and (ActiveControl <> btnCustom2)
    then begin}
    if NotGoingToOneOfTheButtonsToIgnore then begin
      if DoGetCCDep(Self, sCurrCompPath, TXRec.sCostCentre, TXRec.sCostCentre, TRUE, vmShowList, TRUE) then
        begin
          edCostCentre.Text := TXRec.sCostCentre;
          RepopulateOtherThingsAboutAllLines(TXRec, lvLines);
        end
      else ActiveControl := TWinControl(Sender);
    end;{if}
  end;{if}
  EnableDisable;
end;

procedure TFrmTXHeader.edDepartmentExit(Sender: TObject);
begin
  if not bIgnoreOnExits then begin
    TXrec.sDepartment := edDepartment.Text;
{    if (ActiveControl <> btnCancel) and (ActiveControl <> nil)
    and (ActiveControl <> btnCustom1) and (ActiveControl <> btnCustom2)}
    if NotGoingToOneOfTheButtonsToIgnore then begin
      if DoGetCCDep(Self, sCurrCompPath, TXRec.sDepartment, TXRec.sDepartment, FALSE, vmShowList, TRUE) then
        begin
          edDepartment.Text := TXRec.sDepartment;
          RepopulateOtherThingsAboutAllLines(TXRec, lvLines);
        end
      else ActiveControl := TWinControl(Sender);
    end;{if}
  end;{if}
  EnableDisable;
end;

procedure TFrmTXHeader.edAccountCodeExit(Sender: TObject);
var
  sCustCodeBefore, sAccountCode : string20;
  CurrentLineRec : TTXLineRec;

  procedure HOOK_ExitCustCodeBeforeVal;
  begin{HookExitCustCodeBeforeVal}
    {$IFDEF TCCU}  // Trade Counter Customisation
      // Check to see if the event has been enabled by a Plug-In
      if TradeCustomisation.GotEvent(twiTransaction, hpTXExitCustCodeBeforeVal) then begin

        FillChar(CurrentLineRec, SizeOf(CurrentLineRec), #0);

        // Update EventData with current data values
        TradeCustomisation.EventDataO.Assign(Self.Handle, twiTransaction, hpTXExitCustCodeBeforeVal
        , TXRec, lvLines, TKLocationRecord, CurrentLineRec, TKPayLines, Self);

        // Execute the Hook Point Event
        TradeCustomisation.ExecuteEvent;

        // Check the Plug-In changed something
        with TradeCustomisation.EventDataO do begin
          if DataChanged Then Begin
            // Update form with changes
            TXRec.TKTXHeader.CustCode := LTXRec.TKTXHeader.CustCode;
          end;{if}
        end;{with}
      end; { If TradeCustomisation.GotEvent... }
    {$ENDIF}
  end;{HookExitCustCodeBeforeVal}

  procedure HOOK_ExitCustCodeAfterVal;
  var
    iPos : integer;
  begin{HookExitCustCodeAfterVal}
    {$IFDEF TCCU}  // Trade Counter Customisation
      // Check to see if the event has been enabled by a Plug-In
      if TradeCustomisation.GotEvent(twiTransaction, hpTXExitCustCodeAfterVal) then begin

        FillChar(CurrentLineRec, SizeOf(CurrentLineRec), #0);

        // Update EventData with current data values
        TradeCustomisation.EventDataO.Assign(Self.Handle, twiTransaction, hpTXExitCustCodeAfterVal
        , TXRec, lvLines, TKLocationRecord, CurrentLineRec, TKPayLines, Self);

        // Execute the Hook Point Event
        TradeCustomisation.ExecuteEvent;

        // Check the Plug-In changed something
        with TradeCustomisation.EventDataO do begin
          if DataChanged Then Begin
            // Update form with changes
            for iPos := 1 to 5 do TXRec.TKTXHeader.DAddr[iPos] := LTXRec.TKTXHeader.DAddr[iPos];
          end;{if}
        end;{with}
      end; { If TradeCustomisation.GotEvent... }
    {$ENDIF}
  end;{HookExitCustCodeAfterVal}

  procedure RemoveAllMBDLines;
  var
    iLine : integer;
  begin{RemoveAllMBDLines}
    if lvLines.Items.Count > 0 then
    begin
      iLine := 0;
      repeat
        If ttxlineinfo(lvLines.items[iLine].data).txlinerec.bMBDLine then
        begin
          DeleteLines(lvLines, iLine);
        end
        else
        begin
          Inc(iLine);
        end;{if}
      until iLine >= lvLines.Items.Count
    end;{if}
  end;{RemoveAllMBDLines}

  procedure AddAllMBDLines;
  var
    rMBD : Double;
    cMBD : Char;
    iLine, iStatus, iLinesAdded : integer;
    TheTXLineRec : TTXLineRec;
    MBDFrames : TMBDFramesController;
    ExLocal : TdExLocal;
  begin{AddAllMBDLines}
    if lvLines.Items.Count > 0 then
    begin
      iLine := 0;

      ExLocal.Create;
      iStatus := Open_File(F[MultiBuyF], sCurrCompPath + FileNames[MultiBuyF], 0);
      Report_BError(MultiBuyF,iStatus);

      MBDFrames := TMBDFramesController.Create;
      MBDFrames.OnValueChanged := MBDChanged;
      MBDFrames.ScrollBox := sbMBD;
      MBDFrames.IsSales := TRUE;
      MBDFrames.ExLocal := @ExLocal;

      repeat
        TheTXLineRec := ttxlineinfo(lvLines.items[iLine].data).txlinerec;

        PopulateIDRecFromTXLineRec(TheTXLineRec, ExLocal);

//        MBDFrames.StockCode := TheTXLineRec.TKTLRec.StockCode;

        MBDFrames.AddMBDLineFrames(TXRec.TKTXHeader.CustCode, TheTXLineRec.TKTLRec.StockCode
        , DateToStr8(SysUtils.Date), SetupRecord.TillCurrency);

        MBDFrames.StockCode := TheTXLineRec.TKTLRec.StockCode;

        MBDFrames.EnableFrames(TheTXLineRec.TKTLRec.Qty);
        MBDFrames.UpdateQuantities(TheTXLineRec.TKTLRec.Qty);
        MBDFrames.UpdateValues(TheTXLineRec.TKTLRec.Qty, ExLocal.LId.NetValue, ExLocal.LId);
        MBDFrames.GetUnitDiscountValue(rMBD, cMBD);

        TheTXLineRec.rMultiBuyDisc := rMBD;
        TheTXLineRec.cMultiBuyDisc := cMBD;
        if TheTXLineRec.cMultiBuyDisc = '%'
        then TheTXLineRec.rMultiBuyDiscAmount := (TheTXLineRec.rPreEPOSDiscount * TheTXLineRec.rMultiBuyDisc)
        else TheTXLineRec.rMultiBuyDiscAmount := TheTXLineRec.rMultiBuyDisc;
        TheTXLineRec.TKTLRec.tlMultiBuyDiscount := rMBD;
        TheTXLineRec.TKTLRec.tlMultiBuyDiscountChr := cMBD;
//        CalcStockPrice(TXRec, TheTXLineRec, FALSE);
        SetDiscountStr(TheTXLineRec);

        TheTXLineRec.MBDDescLines.Assign(MBDFrames.GetDiscountLineStrings);
        RemoveStockCodesFromMBDDescLines(Trim(TheTXLineRec.TKStockRec.StockCode), TheTXLineRec.MBDDescLines);

        iLinesAdded := AddMBDDescLines(ttxlineinfo(lvLines.items[iLine].data).txlinerec
        , lvLines, iLine, TXRec.TKTXHeader.TransDate);

        ttxlineinfo(lvLines.items[iLine].data).txlinerec := TheTXLineRec; //write back changes

        iLine := iLine + iLinesAdded + 1;
      until iLine >= lvLines.Items.Count;

      Close_File(F[MultiBuyF]);
      ExLocal.Destroy;
      FreeAndNil(MBDFrames);
    end;{if}
  end;{AddAllMBDLines}

  // NF: 21/03/2011 - v6.70.315
  // https://jira.iris.co.uk/browse/ABSEXCH-10297
  procedure InvalidAccount;
  begin {InvalidAccount}
    if (Sender <> nil) and (Sender is TEdit) then ActiveControl := TWinControl(Sender);
    //if (Sender <> nil) then ActiveControl := TWinControl(Sender);
    TxRec.bAccountOK := FALSE;
    lCompanyName.caption := '';
  end; {InvalidAccount}

// NF: 21/03/2011 - v6.70.315
// https://jira.iris.co.uk/browse/ABSEXCH-10297
const
  ACCOUNT_CLOSED = 3;

begin{edAccountCodeExit}
  if not bIgnoreOnExits then begin

//    if ((ActiveControl <> btnCancel) and (ActiveControl <> nil) and (ActiveControl <> btnRetrieveLayaway)
//    and (ActiveControl <> btnFindTX) and (ActiveControl <> btnFindAcc) and (ActiveControl <> btnCreateFrom)
//    and (ActiveControl <> btnCustom1) and (ActiveControl <> btnCustom2)
    if (NotGoingToOneOfTheButtonsToIgnore
    and ((edAccountCode.Text = '') or (not TxRec.bAccountOK) or (TXRec.TKTXHeader.CustCode <> edAccountCode.Text)))
    or (Sender = nil) then
    begin
      sCustCodeBefore := TXRec.TKTXHeader.CustCode;
      TXRec.TKTXHeader.CustCode := edAccountCode.Text;

      HOOK_ExitCustCodeBeforeVal;

      sAccountCode := TXRec.TKTXHeader.CustCode;
      if DoGetCust(Self, sCurrCompPath, sAccountCode, sAccountCode, trdCustomer, vmShowList, TRUE
      , ciAccountCode) then
      begin

        if Cust.CustSupp = 'C' then
        begin

          // NF: 21/03/2011 - v6.70.315
          // Fix for https://jira.iris.co.uk/browse/ABSEXCH-10297
          if (Trim(TXRec.TKTXHeader.OurRef) = '') // Add Mode OR Retrieve Layaway
          and (Cust.AccStatus = ACCOUNT_CLOSED) then
          begin
            MyMsgBox('The account you are trying to use is closed.',mtWarning,[mbOK],mbOK,'Customer Code');
            InvalidAccount;
          end
          else
          begin
            TXRec.LCust := Cust;

            // Get Address
            { CJS 2013-10-22 - MRD2.5.12 - Trade Counter - Delivery Address Postcode }
            if SetupRecord.GetDelAddrFromCustAddr and (not AddressBlank(AddrTyp(TXRec.LCust.DAddr))) then
            begin
              AddrTyp(TXRec.TKTXHeader.Daddr) := TXRec.LCust.DAddr;
              TXRec.TKTXHeader.thDeliveryPostCode := TXRec.LCust.acDeliveryPostCode;
            end
            else
            begin
              AddrTyp(TXRec.TKTXHeader.Daddr) := TXRec.LCust.Addr;
              TXRec.TKTXHeader.thDeliveryPostCode := TXRec.LCust.PostCode;
            end;

            HOOK_ExitCustCodeAfterVal;

            edAccountCode.Text := Trim(sAccountCode);

            TXRec.TKTXHeader.CustCode := sAccountCode;

  //          if Trim(sAccountCode) <> Trim(sCustCodeBefore) then
//            begin
            FillAccountDetails;

            {.305}
            // MBD Lines must be removed and re-added on change of account code
            RemoveAllMBDLines;
            AddAllMBDLines;

            RepopulateOtherThingsAboutAllLines(TXRec, lvLines);

            {.305}
            //Recalc and update display
            RecalcAllTXLines(TXRec, lvLines, FALSE);
            RecalcTXTotals(TXRec, lvLines);
            UpdateDisplay;
//            end;{if}
          end;{if}
        end
        else
        begin
          MyMsgBox('You have entered a supplier code instead of a customer code.',mtError,[mbOK],mbOK,'Customer Code');

          // NF: 21/03/2011 - v6.70.315
          // https://jira.iris.co.uk/browse/ABSEXCH-10297
          InvalidAccount;
{            if Sender <> nil then ActiveControl := TWinControl(Sender);
          TxRec.bAccountOK := FALSE;
          lCompanyName.caption := '';}
        end;{if}
      end
      else
      begin

        // NF: 21/03/2011 - v6.70.315
        // https://jira.iris.co.uk/browse/ABSEXCH-10297
        InvalidAccount;
{        if Sender <> nil then ActiveControl := TWinControl(Sender);
        TxRec.bAccountOK := FALSE;
        lCompanyName.caption := '';}
      end;{if}
    end;{if}
  end;{if}
  EnableDisable;
end;

procedure TFrmTXHeader.EnableDisable;
{enables / disables the appropriate controls}
var
  LTXLineInfo : TTXLineInfo;
begin
  if (LvLines.Selected <> nil) then LTXLineInfo := (TTXLineInfo(LvLines.Selected.Data));

  edCostCentre.Visible := TKSysRec.CCDepts and (SetupRecord.CCDeptMode in [0,2]);
  edDepartment.Visible := TKSysRec.CCDepts and (SetupRecord.CCDeptMode in [0,2]);
  lCostCentre.Visible := TKSysRec.CCDepts and (SetupRecord.CCDeptMode in [0,2]);
  lDepartment.Visible := TKSysRec.CCDepts and (SetupRecord.CCDeptMode in [0,2]);
  Bar1.Visible := TKSysRec.CCDepts and (SetupRecord.CCDeptMode in [0,2]);

  with TXRec do begin
    btnAdd.Enabled := bAccountOK and (TenderMode = tmAdd) and ((not edCostCentre.Visible)
    or ((Trim(edCostCentre.Text) <> '') and (Trim(edDepartment.Text) <> '')));
    btnLayaway.Enabled := btnAdd.Enabled and (lvLines.Items.Count > 0);
    btnEdit.Enabled := bAccountOK and (TenderMode = tmAdd) and (lvLines.Selected <> nil)
    and (LTXLineInfo.TXLineRec.TKTLRec.tlTransValueDiscountType <> 255);
    btnDelete.Enabled := bAccountOK and (TenderMode = tmAdd) and (lvLines.Selected <> nil)
    and (LTXLineInfo.TXLineRec.TKTLRec.tlTransValueDiscountType <> 255);
    btnFindAcc.Enabled := (TenderMode = tmAdd);
    btnFindTX.Enabled := (not bAccountOK) and (TenderMode = tmAdd)
    or (bAccountOK and (not (TenderMode = tmAdd)));
    btnCreateFrom.Enabled := (not bAccountOK) and (TenderMode = tmAdd)
    or (bAccountOK and (not (TenderMode = tmAdd)));

    // MH 26/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount support withdrawn from 01/04/2015
    btnSettlement.Enabled := bAccountOK and (TenderMode = tmAdd) and (lvLines.Items.Count > 0) And SettlementDiscountSupportedForDate (TXRec.TKTXHeader.TransDate);

    if lvLines.Items.Count > 0 then
    begin
      btnDeposit.caption := 'Take Deposit';
      btnDeposit.Enabled := bAccountOK and (lvLines.Items.Count > 0) and (TenderMode <> tmView) and (rOutstanding > 0)
      and (rWrittenOff = 0)
      and ((SetupRecord.NoDepositsOnCashCust = FALSE) or (TXRec.CustType <> ctCashOnly));
    end else
    begin
      btnDeposit.caption := 'On Account';
      btnDeposit.Enabled := bAccountOK and (TenderMode <> tmView);
    end;{if}

    btnTender.Enabled := bAccountOK and (lvLines.Items.Count > 0);
    btnReLogin.Enabled := bAccountOK;
  end;{with}

  edAccountCode.Enabled := (TenderMode = tmAdd);
  edCostCentre.Enabled := (TenderMode = tmAdd);
  edDepartment.Enabled := (TenderMode = tmAdd);
  edCustName.Enabled := (TenderMode = tmAdd);
  edOrderNo.Enabled := (TenderMode = tmAdd);
  edAddress1.Enabled := (TenderMode = tmAdd);
  edAddress2.Enabled := (TenderMode = tmAdd);
  edAddress3.Enabled := (TenderMode = tmAdd);
  edAddress4.Enabled := (TenderMode = tmAdd);
  edAddress5.Enabled := (TenderMode = tmAdd);
  edPostcode.Enabled := (TenderMode = tmAdd);
end;

procedure TFrmTXHeader.FormCreate(Sender: TObject);
var
  iParam : smallint;
  DummyMessage : TMessage;
  TmpJPEG : TJPEGImage;
  SysMenuH       : HWnd;

  function RegisterSecurityServer(sServerName, sFilename : string) : boolean;
  var
    ClsId, CurrDir, SvrPath : ShortString;
    OK                      : Boolean;
//  const
//    sServerName = 'EnterpriseSecurity.ThirdParty';

    procedure ShowError(sError : string);
    begin{ShowError}
      Result := FALSE;
      MyMsgBox(sError,mtError,[mbOK],mbOK,'RegisterSecurityServer Error');
    end;{ShowError}

    procedure FixIt;
    begin{FixIt}
{      If FileExists (CurrDir + 'ENTSECUR.DLL')
      Then RegisterCOMServer(CurrDir + 'ENTSECUR.DLL')
      else ShowError('File Not Found : ' + CurrDir + 'ENTSECUR.DLL');}

      If FileExists (CurrDir + sFilename) Then
      begin
        Case ExtractFileExt(sFilename)[2] of
          'E' : RunApp(CurrDir + sFilename + ' /REGSERVER', True);      // EXE
          'D', 'O' : RegisterCOMServer(CurrDir + sFilename);            // DLL or OCX
        end;{case}
      end
      else ShowError('File Not Found : ' + CurrDir + sFilename);
    end;{FixIt}

  begin{RegisterSecurityServer}
    Result := TRUE;
    if sCentralTradePath <> '' then begin
      With TRegistry.Create Do
      begin
        Try
          Access := KEY_READ;
          RootKey := HKEY_CLASSES_ROOT;

          If KeyExists(sServerName + '\Clsid') Then Begin
            { Key exists - Open key and get the CLSID (aka OLE/COM Server GUID) }
            If OpenKey(sServerName + '\Clsid', False) Then Begin
              If KeyExists('') Then Begin
                { CLSID stored in default entry }
                ClsId := ReadString ('');
                CloseKey;

                { Got CLSID - find entry in CLSID Section and check registered .EXE/.DLL }
                If KeyExists ('Clsid\'+ClsId+'\InprocServer32') Then
                  SvrPath := 'Clsid\'+ClsId+'\InprocServer32'
                Else
                  If KeyExists ('Clsid\'+ClsId+'\LocalServer32') Then
                    SvrPath := 'Clsid\'+ClsId+'\LocalServer32'
                  Else
                    SvrPath := '';

                If (SvrPath <> '') Then Begin
                  { Got Server details - read .EXE/.DLL details and check it exists }
                  If OpenKey(SvrPath, False) Then Begin
                    ClsId := ReadString ('');

                    If FileExists (ClsId) Then Begin
                      { Got File - Check its in current directory }
                      ClsId   := UpperCase(Trim(ExtractShortPathName(ExtractFilePath(ClsId))));
                      CurrDir := UpperCase(Trim(ExtractShortPathName(Copy(sCentralTradePath, 1, length(sCentralTradePath) - 6))));

                      If (ClsId <> CurrDir)
                      Then FixIt;
                      //ShowError('Error Found - Incorrect Executable Path');
                    End { If }
                    Else
                      { Registered OLE Server doesn't actually exist }
                      ShowError('Error Found - Server Missing');
                  End { If }
                  Else
                    ShowError('Error Found - Cannot open Server Details');
                End { If (SvrPath <> '') }
                Else
                  ShowError('Error Found - No Server Details Found');
              End { If KeyExists('') }
              Else
                ShowError('Error Found - Server Class Id Missing');
            End { If OpenKey(sServerName + '\Clsid', False) }
            Else
              ShowError('Error Found - Cannot open Server Class Id');
          End { If KeyExists(sServerName + '\Clsid') }
          Else begin
            CurrDir := UpperCase(Trim(ExtractShortPathName(Copy(sCentralTradePath, 1, length(sCentralTradePath) - 6))));
            FixIt;
          end;{if}
  //          ShowError('Error Found - Server Class Id Entry Missing');

          CloseKey;
        Finally
          Free;
        End;{try}
      End;{with}
    End;{if}
  end;{RegisterSecurityServer}

  Procedure SetPluginFlags;
  var
    I : integer;
  begin{SetPluginFlags}
    {$IFDEF TCCU}  // Trade Counter Customisation

      // See which plugins are installed
      if (TradeCustomisation.PlugInCount > 0) Then
      begin
        bCommideaPlugInRunning := FALSE;
        for I := 0 To Pred(TradeCustomisation.PlugInCount) Do
        begin
          if UpperCase(TradeCustomisation.PlugIns[I].piClassName)
          = 'ENTERPRISETRADEPLUGIN.PDQWEDGE' then bCommideaPlugInRunning := TRUE;
        end;{for}
      end;{if}
    {$ENDIF}
  end;{SetPluginFlags}

begin{FormCreate}

  if (not RegisterSecurityServer('EnterpriseSecurity.ThirdParty', 'ENTSECUR.DLL'))
  or (not RegisterSecurityServer('Enterprise.OLEServer', 'ENTEROLE.EXE'))
  or (not RegisterSecurityServer('Enterprise01.Toolkit', 'ENTTOOLK.DLL')) then
  begin
    bForceClose := TRUE;
    bDontAskOnExit := TRUE;
    PostMessage(Self.Handle,WM_Close,0,0);
    exit;
  end;{if}

  SysColorMode := ColorMode(canvas);

  // HM 31/01/02: Added code to switch application title
  Application.OnActivate   := ApplicationActive;
  Application.OnDeactivate := EntDeActivate;
  Application.OnMinimize   := EntDeActivate;
  Application.OnRestore    := ApplicationActive;

  {Get company path from TRADE.INI}
  with TIniFile.Create(ExtractFilePath(Application.ExeName) + 'TRADE.INI') do begin
    try
      eBSetDrive := ReadString('Settings', 'CompanyPath', '');
    finally
      Free;
    end;{try}
  end;{with}

  bShowStock := FALSE;
  sCurrCompPath := '';
  bForceClose := FALSE;
  lvLines.Tag := 1; //iNextListFolioNo := 1;

  frmBackground := TfrmBackground.Create(Self);
  frmBackground.Show;

  bDrawBitmaps := TRUE;
  sBackground := 'GREYBACK';
  For iParam := 1 to ParamCount do begin
    if UpperCase(Paramstr(iParam)) = '/NL:' then bDrawBitmaps := FALSE;

    if UpperCase(Copy(Paramstr(iParam),1,12)) = '/BACKGROUND='
    then sBackground := Copy(Paramstr(iParam),13,255);

  end;{for}

  if not bDrawBitmaps then SysColorMode := cm256Colors;

  if bDrawBitmaps then begin
    FillChar(DummyMessage,SizeOf(DummyMessage),#0);
    frmBackground.DrawBackGround(DummyMessage);
  end;{if}

  {Load Background JPEG}
  TmpJPEG := TJPEGImage.Create;
  bitFormBackground := TBitmap.create;
  if LoadJPEGFromRes('FORMBAK2', TmpJPEG) then bitFormBackground.Assign(TmpJPEG);
  TmpJPEG.Free;

  if SysColorMode in ValidColorSet then DrawFormBackground(self, bitFormBackground);

  if AskLogin then
    begin
      InitialiseForm;

      SysMenuH:=GetSystemMenu(Handle,False);
      AppendMenu(SysMenuH,MF_SEPARATOR,0,'');
      AppendMenu(SysMenuH,MF_String,CM_DisplayAbout,'&About Trade Counter');

      {$IFDEF TCCU}  // Trade Counter Customisation
//        StartCustomisation;

        // Check to see if the Custom Buttons have been enabled by a Plug-In
        btnCustom1.Visible := TradeCustomisation.GotEvent (twiTransaction, hpTXHeadCustom1);
        If btnCustom1.Visible Then btnCustom1.Caption := TradeCustomisation.CustomText (twiTransaction, hpTXHeadCustom1, btnCustom1.Caption);
        SendMessage(btnCustom1.Handle,CM_MOUSEENTER,0,0); {redraw button}

        // Check to see if the Custom Buttons have been enabled by a Plug-In
        btnCustom2.Visible := TradeCustomisation.GotEvent (twiTransaction, hpTXHeadCustom2);
        If btnCustom2.Visible Then btnCustom2.Caption := TradeCustomisation.CustomText (twiTransaction, hpTXHeadCustom2, btnCustom2.Caption);
        SendMessage(btnCustom2.Handle,CM_MOUSEENTER,0,0); {redraw button}

        SetPluginFlags;

      {$ENDIF}
    end
  else begin
    bDontAskOnExit := TRUE;
    PostMessage(Self.Handle,WM_Close,0,0);
    bForceClose := TRUE;
  end;{if}

end;

procedure TFrmTXHeader.FillAccountDetails;
{fills the form's account details from the customer record}

  Function SetTransNat(DocHed : string) : Byte;
  const
    VATINVTTyp     =  10; {*         "      "       Invoices    *}
    VATCRDTTyp     =  16; {* Intra Stat defaults  - Credit note *}
    VATIEINVTTyp   =  1; {*         "      "       Invoices    *}
    IECCode        =  '353';  { Ireland Country code }
  Begin
    If (TKSysRec.CurrentCountry <> IECCode) then
      Begin
        If (DocHed = 'SRF') or (DocHed = 'PRF') or (DocHed = 'SCR') or (DocHed = 'PCR')
        or (DocHed = 'SJC') or (DocHed = 'PJC') then Result:=VATCRDTTyp
        else Result:=VATInvTTyp;
      end
    else Result:=VATIEInvTTyp;
  end;{SetTransNat}

begin
  with TXRec, LCust do begin

    TKTXHeader.LongYrRef := Contact;

    edAccountCode.Text := TKTXHeader.CustCode;

    if SetupRecord.CCDeptMode = 0 then begin
      if (trim(CustCC) <> '') then begin
        sCostCentre := CustCC;
//        edCostCentreExit(edCostCentre);
      end;{if}

      if (trim(CustDep) <> '') then begin
        sDepartment := CustDep;
//        edDepartmentExit(edDepartment);
      end;{if}
    end;{if}

    FillFormFromTXRec;

    // MH 26/02/2015 v7.0.13 ABSEXCH-15298: Settlement Discount support withdrawn from 01/04/2015
    If SettlementDiscountSupportedForDate (TXRec.TKTXHeader.TransDate) Then
    Begin
      TKTXHeader.DiscSetl := DefSetDisc / 100;
      TKTXHeader.DiscDays := DefSetDDays;
    End; // If SettlementDiscountSupportedForDate (TXRec.TKTXHeader.TransDate)

(*    edAccountCode.Text := TKTXHeader.CustCode;

    if SetupRecord.CCDeptMode = 0 then begin
      if (trim(CustCC) <> '') then begin
        edCostCentre.Text := CustCC;
        edCostCentreExit(edCostCentre);
      end;{if}

      if (trim(CustDep) <> '') then begin
        edDepartment.Text := CustDep;
        edDepartmentExit(edDepartment);
      end;{if}
    end;{if}

    TKTXHeader.DiscSetl := DefSetDisc / 100;
    TKTXHeader.DiscDays := DefSetDDays;
    edAddress1.Text := Addr[1];
    edAddress2.Text := Addr[2];
    edAddress3.Text := Addr[3];
    edAddress4.Text := Addr[4];
    edAddress5.Text := Addr[5];
    lCompanyName.Caption := Trim(Company);
    edCustName.Text := Trim(Contact);*)

    if TKSysRec.IntraStat and EECMember then begin
      TKTXHeader.SSDProcess := ' ';

      TKTXHeader.DelTerms := SSDDelTerms;
      if TKTXHeader.DelTerms = '' then TKTXHeader.DelTerms := SetupRecord.DefSSDDeliveryTerms;

      TKTXHeader.TransMode := SSDModeTr;
      if TKTXHeader.TransMode = 0 then TKTXHeader.TransMode := SetupRecord.DefSSDModeOfTrans;

      TKTXHeader.TransNat := SetTransNat(Trim(TKTXHeader.TransDocHed));
    end;{if}

    if bAccountOK then
      begin
        RecalcAllTXLines(TXRec, lvLines, TRUE);
        RecalcTXTotals(TXRec, lvLines);
        UpdateDisplay;
      end
    else bAccountOK := TRUE;

    {Work Out Customer Type}
    if AccStatus > 1 then
      begin
        CustType := ctOnHold;
        if TenderMode in [tmAdd, tmEdit] then begin
          MyMsgBox('This customer is not currently allowed credit.' + #13#13
          + 'Any transactions made must be settled in full',mtWarning,[mbOK],mbOK,'Customer Status');
        end;{if}
      end
    else begin
      if (Payterms = 0) or (UpperCase(RepCode) = UpperCase(SetupRecord.CashCustType)) then CustType := ctCashOnly
      else begin
        if CreditCheck(Cust, 0) then CustType := ctNormal
        else begin
          if (SetupRecord.TransactionType = TX_UNPICKED_SORs) then TXRec.TKTXHeader.HoldFlg := 6;
          if TKSysRec.StopBadDr then CustType := ctOnHold
          else CustType := ctNormal;
        end;{if}
      end;{if}
    end;{if}

  end;{with}
  EnableDisable;
end;

procedure TFrmTXHeader.btnSettlementClick(Sender: TObject);
var
  NewActiveControl : TWinControl;
begin
  if TWinControl(Sender).Enabled then begin
    NewActiveControl := ActiveControl;
    ActiveControl := btnSettlement;
    with TFrmSettlement.Create(Self) do begin
      try
        edSettlement.Value := TXRec.TKTXHeader.DiscSetl * 100;
        edSettDiscDays.Value := TXRec.TKTXHeader.DiscDays;
        if ShowModal = mrOK then begin
          TXRec.TKTXHeader.DiscSetl := edSettlement.Value / 100;
          TXRec.TKTXHeader.DiscDays := Round(edSettDiscDays.Value);
          RecalcAllTXLines(TXRec, lvLines, FALSE);
          RecalcTXTotals(TXRec, lvLines);
          UpdateDisplay;
        end;{if}
      finally
        Release;
      end;{try}
    end;{with}
    ActiveControl := NewActiveControl;
  end;{if}
end;
(*
function TFrmTXHeader.AddTXLine(var TheTXLineRec : TTXLineRec; var iInsertIndex : integer
; rPrevQty : real = 0; bExplodeBOMs : boolean = TRUE) : integer;
{adds a new line into the list}
var
  NewItem : TListItem;
  iLine : smallint;
  iPos : byte;
  DescLineRec : TTXLineRec;
  iFocusItem, iPrevFolioNo : integer;
  MainTXLineInfo : TTXLineInfo;

  procedure AddEditBOMItems;
  var
    pStockCode : PChar;
    BOMRec : TBatchBOMLinesRec;
    iLine, iBOMItemCount, iStatus : integer;
    BOMTXLineRec : TTXLineRec;

    procedure ZeroValues(var TheBOMTXLineRec : TTXlineRec);
    begin
      with TheBOMTXLineRec do begin
        sDiscount := '-';
        rDiscAmount := 0;
        rPreEPOSDiscount := 0;
        rNetPrice := 0;
        TKTLRec.VAT := 0;
        rTotalLineVATAmount := 0;
        rLineTotal := 0;
        rLineNetTotal := 0;
      end;{with}
    end;{ZeroValues}

    procedure UpdateBOMLines(var BOMTXLineRec : TTXLineRec);
    var
      iLine, iPos : integer;
    begin{UpdateBOMLines}
      with BOMTXLineRec, LvLines do begin
        For iPos := 0 to length(BOMComponents) - 1 do begin
          For iLine := 0 to Items.Count - 1 do begin
            if TTXLineInfo(Items.Item[iLine].Data).TXLineRec.iListFolioNo
            = BOMTXLineRec.BOMComponents[iPos] then begin
              TTXLineInfo(Items.Item[iLine].Data).TXLineRec.TKTLRec.Qty
              := (TTXLineInfo(Items.Item[iLine].Data).TXLineRec.TKTLRec.Qty / rPrevQty)
              * TheTXLineRec.TKTLRec.Qty;

              If BOMTXLineRec.TKStockRec.StKitPrice then ZeroValues(TTXLineInfo(Items.Item[iLine].Data).TXLineRec)
              else TTXLineInfo(Items.Item[iLine].Data).RecalcLine(TXRec, TRUE);

              TXLineRecToItem(TTXLineInfo(Items.Item[iLine].Data).TXLineRec, Items.Item[iLine]);
              if TTXLineInfo(Items.Item[iLine].Data).TXLineRec.bBOM then UpdateBOMLines(TTXLineInfo(Items.Item[iLine].Data).TXLineRec);
            end;{if}
          end;{for}
        end;{for}
      end;{with}
    end;{UpdateBOMLines}

  begin{AddEditBOMItems}

    TheTXLineRec.bBOM := TRUE;

    case iPrevFolioNo of
      0 : begin // New Item Added - Add BOM Items
        pStockCode := StrAlloc(21);
        StrPCopy(pStockCode,TheTXLineRec.TKTLRec.StockCode);
        iStatus := EX_GETSTOCKBOM(@BOMRec,SizeOf(BOMRec), pStockCode, 0);
        if Status = 0 then
          begin
            iBOMItemCount := 1;
            while (length(Trim(BOMRec[iBOMItemCount].StockCode)) > 0) and (iBOMItemCount <= 500) do begin

              InitialiseTXLine(BOMTXLineRec);
//              FillChar(BOMTXLineRec, SizeOf(BOMTXLineRec), #0);

              FillTXLineRec(TXRec, BOMTXLineRec, BOMRec[iBOMItemCount].StockCode
              , BOMRec[iBOMItemCount].QtyUsed * TheTXLineRec.TKTLRec.Qty);

              BOMTXLineRec.iBOMParentFolioNo := TheTXLineRec.iListFolioNo;
              BOMTXLineRec.rBOMQtyUsed := BOMRec[iBOMItemCount].QtyUsed;
              BOMTXLineRec.TKTLRec.KitLink := iStockFolio;
              BOMTXLineRec.bBOMComponent := TRUE;

              // Zero Price, if Price comes from BOM Header
              If TheTXLineRec.TKStockRec.StKitPrice then ZeroValues(BOMTXLineRec);

              Inc(iInsertIndex);
              SetLength(TheTXLineRec.BOMComponents, length(TheTXLineRec.BOMComponents) + 1);
              PopulateOtherThingsAboutThisLine(TXRec, BOMTXLineRec, (iInsertIndex + 1) * 2);
              TheTXLineRec.BOMComponents[length(TheTXLineRec.BOMComponents) - 1]
              := AddTXLine(BOMTXLineRec, iInsertIndex);
              UpdateDisplay;

              inc(iBOMItemCount);
            end;{while}
          end
        else ShowTKError('EX_GETSTOCKBOM', 46, iStatus);
        StrDispose(pStockCode);
      end;

      else begin // BOM Items already added, update items
        if rPrevQty <> 0 then begin
          with LvLines do begin
            For iLine := 0 to Items.Count - 1 do begin
              with TTXLineInfo(Items.Item[iLine].Data), TXLineRec do begin
//                if iBOMParentFolioNo = iPrevFolioNo then begin
                if (iListFolioNo = TheTXLineRec.iListFolioNo) then begin
                  UpdateBOMLines(TXLineRec);
                  Break;
                end;{if}
              end;{with}
            end;{for}
          end;{with}
        end;{if}
      end;

    end;{case}
  end;{AddEditBOMItems}

begin{AddTXLine}

//  FillChar(DescLineRec, SizeOf(DescLineRec), #0);
  InitialiseTXLine(DescLineRec);
  DescLineRec.TKTLRec.Qty := 0;
  DescLineRec.bDescLine := TRUE;
  DescLineRec.bSerial := FALSE;

  with TheTXLineRec do begin
    iPrevFolioNo := iListFolioNo;
    if iListFolioNo = 0 then iListFolioNo := GetNextListFolioNo;
    Result := iListFolioNo;
    bDescLine := FALSE;
//    bDescLine := (TKTLRec.KitLink <> 0) and (Trim(TKTLRec.StockCode) = '');
    iDescLines := 0;
    For iLine := 1 to 6 do begin
      if TKStockRec.Desc[iLine] <> '' then inc(iDescLines);
    end;{for}

    For iLine := 0 to TheTXLineRec.iDescLines - 1 do begin

      {adds the new line}
      NewItem := lvLines.Items.Insert(iInsertIndex + iLine);

      {inserts blank subitems to be filled in later by "TXLineRecToItem"}
      For iPos := 1 to 5 do NewItem.SubItems.Add('');

      if iLine = 0 then
      begin
        {fills the 1st line}
        TXLineRecToItem(TheTXLineRec, NewItem);

        {adds the TXLineRec object to the line}
        MainTXLineInfo := TTXLineInfo.Create(TheTXLineRec);
        NewItem.Data := MainTXLineInfo;

        if (TKStockRec.StockType = 'M') and TKStockRec.ShowAsKit then NewItem.ImageIndex := 1
        else begin
          if TheTXLineRec.bBOMComponent then NewItem.ImageIndex := 2;
        end;{if}

      end else
      begin
        {fills the description line}
        NewItem.SubItems[0] := TKStockRec.Desc[iLine + 1];

        {adds the "Description Only" TXLineRec object to the line}
        if DescLineRec.TKTLRec.LineNo = 0 then DescLineRec.TKTLRec.LineNo := (iLine + 1) * 2;
        DescLineRec.sDesc := TKStockRec.Desc[iLine + 1];
        DescLineRec.bNonStock := TheTXLineRec.bNonStock;{.281}

        if TheTXLineRec.bNonStock
        then DescLineRec.TKTLRec.KitLink := SET_TO_TX_FOLIO_NO_ON_STORE;{.281} // By setting the kit link to this "magic number", on storing the TX, the toolkit will then set the Kitlink to the folio number of the transaction, once it knows what it is.


        NewItem.Data := TTXLineInfo.Create(DescLineRec);
        NewItem.ImageIndex := -1;
      end;{if}

    end;{for}

    // Bill Of Materials Item
    iFocusItem := iInsertIndex;
    if (TKStockRec.StockType = 'M') and TKStockRec.ShowAsKit and bExplodeBOMs then begin
      AddEditBOMItems;
      MainTXLineInfo.TXLineRec := TheTXLineRec; // update the list items info
    end;{if}


  end;{with}


  {focuses the 1st line of the newly added line}
  with lvLines do begin
//    Selected := Items.Item[iInsertIndex];
//    ItemFocused := Items.Item[iInsertIndex];
    Selected := Items.Item[iFocusItem];
    ItemFocused := Items.Item[iFocusItem];
  end;{with}

  {Updates display}
  RecalcTXTotals(TXRec, lvLines);
  UpdateDisplay;
end;{AddTXLine}
*)
procedure TFrmTXHeader.lvLinesDblClick(Sender: TObject);
begin
  btnEditClick(btnEdit);
end;

procedure TFrmTXHeader.FocusFirstLine;
{Highlights the first line of the stock item (i.e. not a "description only" line)}
var
  iPos : integer;
begin
  with lvLines do begin
    if TTXLineInfo(Selected.Data).TXLineRec.bDescLine then begin
      {find first line for item}
      iPos := Selected.Index;
      Repeat
        Dec(iPos);
      Until TTXLineInfo(Items.Item[iPos].Data).TXLineRec.bDescLine = FALSE;

      {focus first line for item}
      Selected := Items.Item[iPos];
      ItemFocused := Items.Item[iPos];
    end;{if}
  end;{with}
end;

procedure TFrmTXHeader.RecalcColWidths;
{sizes the description column width dependant on the number of items in the list}
begin
  if lvLines.Items.Count > lvLines.VisibleRowCount then
    begin
      lvLines.Columns[1].Width := 199;
    end
  else begin
    lvLines.Columns[1].Width := 215;
  end;
end;

procedure TFrmTXHeader.ScrollList;
{Makes Sure that the selected item is visible}
var
  iRowScroll : smallint;
begin
  with lvLines do begin
    iRowScroll := Items.Count - TopItem.Index - VisibleRowCount;
    if iRowScroll > 0 then Scroll(0,(16 * iRowScroll));
  end;{with}
end;

procedure TFrmTXHeader.ClearTX;
{Blanks the transaction & the screen}

  procedure HOOK_TXInitialise;
  var
    CurrentLineRec : TTXLineRec;
  begin{HOOK_TXInitialise}
    {$IFDEF TCCU}  // Trade Counter Customisation
      // Check to see if the event has been enabled by a Plug-In
      If TradeCustomisation.GotEvent(twiTransaction, hpTXInitialise) Then Begin

        FillChar(CurrentLineRec, SizeOf(CurrentLineRec), #0);

        // Update EventData with current data values
        TradeCustomisation.EventDataO.Assign(Self.Handle, twiTransaction, hpTXInitialise
        , TXRec, lvLines, TKLocationRecord, CurrentLineRec, TKPayLines, Self);

        // Execute the Hook Point Event
        TradeCustomisation.ExecuteEvent;

        // Check to see if the Plug-In changed something (not that it's allowed to)
        with TradeCustomisation.EventDataO do begin
          if DataChanged Then Begin
            // Update with changes
//            TXRec := LTXRec;
//            CopyListViewItems(LListView.Items, lvLines.Items);
//            RecalcAllTXLines(TXRec, lvLines, TRUE);
//            RecalcTXTotals(TXRec, lvLines);
//            FillFormFromTXRec;
//            UpdateDisplay;
          end;{if}
        end;{with}
      end; { If TradeCustomisation.GotEvent... }
    {$ENDIF}
  end;{HOOK_TXInitialise}

begin
  SetupRecord.TransactionType := iOrigTXType; //Resets TXType to the Original System setup value

  FillChar(TKPayLines,SizeOf(TKPayLines),#0);

  lvLines.Tag := 1; //iNextListFolioNo := 1;
  Caption := 'New Transaction';
  TenderMode := tmAdd;
  FillChar(Cust, SizeOf(Cust), #0);

  FillChar(TXRec, SizeOf(TXRec), #0);
  TXRec.LCust := Cust;
  AddrTyp(TXRec.TKTXHeader.Daddr) := TXRec.LCust.Addr;
  FillAccountDetails;

  TxRec.bAccountOK := FALSE;

  FillStandardTXHead(TXRec.TKTXHeader);

  edAccountCode.Text := '';
  edCostCentre.Text := '';
  edDepartment.Text := '';
  edOrderNo.Text := '';
  lvLines.Items.Clear;
  RecalcTXTotals(TXRec, lvLines);
  UpdateDisplay;
  EnableDisable;
  bIgnoreOnExits := TRUE;
  ActiveControl := edAccountCode;
  bIgnoreOnExits := FALSE;
  RecalcColWidths;
  FillDefaults;

  HOOK_TXInitialise;

end;

procedure TFrmTXHeader.GetTXDetails(bFind : boolean; bReverse : boolean = FALSE);
var
  iPos : byte;
  TKMatchRec : TBatchMatchRec;
//  TKTXHeader : TBatchTHRec;
  TKTLines : TBatchLinesRec;
  LTKTXHeader : TBatchTHRec;
  pStockCode, pLocation, pYourRef, pOurRef : PChar;
  iExtraDescLine, iStatus, iStatus2 : smallint;
  rWrittenOffB4, rTemp : real;
  bClear, bCurrItemIsNonStock : boolean;
  sMessage : string;
  iLine, iInsertIndex : integer;
  MBDTXLineRec, NewTXLineRec : TTXLineRec;
  NewItem : TListItem;

  function TKTLLine2TXLineRec(TKTXLine : TBatchTLRec) : TTXLineRec;
  var
    iStatus : integer;
    pStockCode : PChar;
    LTXLineRec : TTXLineRec;
    LTKTLRec, VatTKTLRec : TBatchTLRec;
  begin{TKTLLine2TXLineRec}

    if TKTXLine.Payment = TRUE then Exit;
//    if ((TKTXLine.KitLink <> 0) and (Trim(TKTXLine.StockCode) = '')) then Exit;
//    if ((TKTXLine.KitLink > 0) and (Trim(TKTXLine.StockCode) = '')) then Exit;{.281}
//    Removed, as it was causing problems when loading transaction using find, with non-stock items with additional description lines


  {  if (TKTXLine.KitLink <> 0) and (Trim(TKTXLine.StockCode) = ''))) then begin {only add non-description lines}
  {  if not ((TKTXLine.Payment = TRUE)
    or ((TKTXLine.KitLink <> 0) and (Trim(TKTXLine.StockCode) = ''))) then begin {only add non-description lines}
  //  if ((TKTXLine.KitLink = 0) and (TKTXLine.Payment = FALSE))
  //  or ((TKTXLine.KitLink = 1) and (Trim(TKTXLine.StockCode) = '')) then begin {only add non-description lines}

    InitialiseTXLine(Result);
    Result.TKTLRec := TKTXLine;

    with TKTXLine do begin

//      Result.bDescLine := (KitLink > 0) and (Trim(TKTXLine.StockCode) = '');
      Result.bDescLine := (KitLink <> 0) and (Trim(TKTXLine.StockCode) = '')
      and (TKTXLine.tlTransValueDiscountType <> 255);{.281}
      Result.bMBDLine := (TKTXLine.tlTransValueDiscountType = 255);

      Result.bStockOK := TRUE;
//      Result.TKTLRec.StockCode := StockCode;
//      Result.TKTLRec.Qty := Qty;

      if ZeroFloat(Discount) then Result.cDiscount := ' '
      else Result.cDiscount := DiscountChr;
      if Result.cDiscount = ' ' then Result.cDiscount := DT_DISCOUNT_AMOUNT;  //NF: Added 2/11/2005 as these were being interpreted as % discounts

      Result.rDiscount := Discount * (1 + (99 * Ord(Result.cDiscount = DT_PERCENTAGE)));

      Result.rPreEPOSDiscount := NetValue;

(*
case Result.cDiscount of
  '%' : begin
    Result.rDiscount := (Result.rPreEPOSDiscount * ((100 - Result.rDiscount) / 100));
    Result.rNetPrice := Result.rDiscount;
  end;

  #0, ' ' : begin
    Result.rDiscount := Result.rPreEPOSDiscount - Result.rDiscount;
    Result.rNetPrice := Result.rDiscount;
  end;

  else begin
    Result.rNetPrice := Result.rPreEPOSDiscount;
  end;
end;{case}
// Always set to override, so that old prices are maintained
Result.cDiscount := '£';
Result.sDiscount := 'override';
Result.rPreEPOSDiscount := Result.rNetPrice;
Result.rNonDiscLineNetTotal := Result.rNetPrice;
*)


//(*
      case Result.cDiscount of
        DT_PERCENTAGE : begin
//          Result.sDiscount := MoneyToStr(Result.rDiscount) + ' %';
          Result.rNetPrice := Result.rPreEPOSDiscount * ((100 - Result.rDiscount) / 100)
        end;

        DT_DISCOUNT_AMOUNT, ' ' : begin
//          Result.sDiscount := sCurrencySym + ' ' + MoneyToStr(Result.rDiscount);
          Result.rNetPrice := Result.rPreEPOSDiscount - Result.rDiscount;
        end;

//        DT_OVERRIDE_PRICE : Result.sDiscount := 'override';
//        else Result.sDiscount := '-';
      end;{case}

      SetDiscountStr(Result);

      Result.rDiscAmount := Result.rPreEPOSDiscount - Result.rNetPrice;
//*)

      Result.TKTLRec.VAT := VAT;
      Result.TKTLRec.VATCode := VATCode;

      if Trim(StockCode) = '' then
        begin
          Result.TKStockRec.Desc[1] := TKTXLine.Desc;
          Result.sDesc := TKTXLine.Desc;
          Result.bSerial := FALSE;
        end
      else begin
        pStockCode := StrAlloc(255);
        StrPcopy(pStockCode,StockCode);
        iStatus := Ex_GetStock(@Result.TKStockRec, SizeOf(Result.TKStockRec), pStockCode, 0, B_GetEq, FALSE);
        StrDispose(pStockCode);
        ShowTKError('Ex_GetStock', 80, iStatus);

        if iStatus = 0 then begin
          with Result.TKStockRec do begin
            Result.bSerial := ((StkValType = 'A') and (SerNoWAvg = 1)) or (StkValType = 'R');
          end;{with}
        end;{if}
      end;{if}

      {.201}
      VatTKTLRec := Result.TKTLRec;
      VatTKTLRec.Qty := 1;
      if Result.TKStockRec.PriceByStkUnit then VatTKTLRec.Qty := VatTKTLRec.Qty / Result.TKStockRec.SellUnit;
      iStatus := Ex_CalcLineTax(@VatTKTLRec, sizeof(VatTKTLRec),TXRec.TKTXHeader.DiscSetl);
      ShowTKError('Ex_CalcLineTax', 144, iStatus);
      VatTKTLRec.NetValue := Round_Up(VatTKTLRec.NetValue, TKSysRec.PriceDP); // Rounding fix for ireland (.249}

      // v6.50.312 07/10/2010 - set vat differently when finding a transaction
      // Bug Fix for https://jira.iris.co.uk/browse/ABSEXCH-2662
      if bFind then
      begin
        Result.rTotalLineVATAmount := Result.TKTLRec.VAT;
      end
      else
      begin
        Result.rTotalLineVATAmount := VatTKTLRec.VAT;
      end;
      //Result.rTotalLineVATAmount := VatTKTLRec.VAT;

      Result.rPrice := Result.rNetPrice + Result.rTotalLineVATAmount;
      LTXLineRec := Result;
      LTKTLRec := Result.TKTLRec;
      DoDiscountLineTotal(LTXLineRec, LTKTLRec, Result.TKTLRec.Qty, Result.rLineNetTotal, TRUE);
      Result.rLineTotal := Result.rLineNetTotal + Result.TKTLRec.VAT;

//      Result.rTotalLineVATAmount := SafeDiv(VAT, Qty);
//      Result.rPrice := Result.rNetPrice + Result.rTotalLineVATAmount;
//      Result.rLineTotal := Result.rPrice * Qty;
//      Result.rLineNetTotal := Result.rNetPrice * Qty;

      // Read Advanced Discounts
      Result.rDiscount3 := tlTransValueDiscount;
      Result.cDiscount3 := tlTransValueDiscountChr;
      Result.iDiscount3Type := tlTransValueDiscountType;

      Result.rMultiBuyDisc := tlMultiBuyDiscount;
      Result.cMultiBuyDisc := tlMultiBuyDiscountChr;

      {.303}
//      if Result.cMultiBuyDisc = '%' then Result.rMultiBuyDiscAmount := (Result.rNetPrice * Result.rMultiBuyDisc)
//      else Result.rMultiBuyDiscAmount := Result.rMultiBuyDisc;
      {.304}
      if Result.cMultiBuyDisc = '%' then Result.rMultiBuyDiscAmount := (Result.rPreEPOSDiscount * Result.rMultiBuyDisc)
      else Result.rMultiBuyDiscAmount := Result.rMultiBuyDisc;

    end;{with}
  end;{TKTLLine2TXLineRec}

begin{GetTXDetails}

  if (Copy(Inv.OurRef,1,3) = 'SCR') or (Copy(Inv.OurRef,1,3) = 'SRF')
  then bReverse := not bReverse; {.202}

  if bFind then Caption := 'Transaction - ' + Inv.OurRef
  else Caption := 'New Transaction';

  FillChar(TXRec, SizeOf(TXRec), #0);
  TXRec.bReversed := bReverse;
  lvLines.Items.Clear;

  // NF: 21/03/2011 - v6.70.315
  // https://jira.iris.co.uk/browse/ABSEXCH-10297
  // We need this so that we can tell in "edAccountCodeExit" which mode we are in (add/edit/etc.)
  TXRec.TKTXHeader.OurRef := Inv.OurRef;

  {Get Cust Record}
  edAccountCode.Text := Inv.CustCode;
  edAccountCodeExit(nil);

  {Fill TX Header}
  with TXRec do begin

    with Cust do begin
      TKTXHeader.OurRef := Inv.OurRef;
      if bFind then iFolioNum := Inv.FolioNum;
      TKTXHeader.CustCode := Inv.CustCode;
      DefSetDisc := Inv.DiscSetl * 100;
      TKTXHeader.DiscSetl := DefSetDisc / 100;
      TKTXHeader.DiscDays := DefSetDDays;
      For iPos := 1 to 5 do TKTXHeader.DAddr[iPos] := Inv.DAddr[iPos];
      Contact := Inv.TransDesc;
    end;{with}
    edOrderNo.Text := Inv.YourRef;
  {  FillAccountDetails;}

    {Fill TX Lines}
  //  FillChar(TKTXHeader, SizeOf(TKTXHeader), #0);
    FillChar(TKTLines, SizeOf(TKTLines), #0);

    {Get Main TX}
    pOurRef := StrAlloc(255);
    StrPCopy(pOurRef,TXRec.TKTXHeader.OurRef);
    iStatus := Ex_GetTrans(@TKTXHeader, @TKTLines, SizeOf(TKTXHeader), SizeOf(TKTLines), pOurRef, 0, B_GetEq, FALSE);

    if iStatus = 0 then
      begin

        // initialise values that will be populated later
  //      TKTXHeader.InvNetVal := 0;
  //      TKTXHeader.InvVat := 0;
  //      TKTXHeader.Settled := 0;
  //      FillChar(TKTXHeader.InvVatAnal, SizeOf(TKTXHeader.InvVatAnal),#0);

        if bReverse then begin
          NegateTKTXHeader(TKTXHeader);
          NegateTKTLines(TKTLines, TKTXHeader);
        end;{if}

        if not bFind then TxRec.TKTXHeader.OurRef := '';

        with TxRec do begin
      //    TKTXHeader.DiscTaken := TKTXHeader.DiscTaken;
          TKTXHeader.DiscSetAm := TKTXHeader.DiscSetAm * WordBoolOrd(TKTXHeader.DiscTaken);
        end;{with}

        // Go through all lines of the Main TX
        For iPos := 1 to TKTXHeader.LineCount do
        begin

          if (not bFind) and (not bReverse) //Create from (non reverse)
          and (TKTLines[iPos].tlTransValueDiscountType = 255)
          and (ZeroFloat(TKTLines[iPos].Qty)) then
          begin
            // "Create From" and TTD/VBD Desc Line
            // Skip this line
          end else
          begin

            // Create From (copy) - Blank out all TTD/VBDs
            if (not bFind) and (TKTLines[iPos].tlTransValueDiscountType <> 255) and (not bReverse) then
            begin
              TKTLines[iPos].tlTransValueDiscount := 0;
              TKTLines[iPos].tlTransValueDiscountChr := #0;
              TKTLines[iPos].tlTransValueDiscountType := 0;
            end;{if}

            // Work out written off value on the main tx
            if bFind and (TKTLines[iPos].Desc = 'Discount (write-off)') then TXRec.rWrittenOff := TXRec.rWrittenOff
            + ABS(TKTLines[iPos].NetValue);

            if TKTLines[iPos].Payment then {Payment Line ?}
              begin
                // Work out deposit value on the main tx
                if bFind and (TKTLines[iPos].Desc <> 'Discount (write-off)') then TXRec.rDepositsTaken := TXRec.rDepositsTaken + TKTLines[iPos].NetValue;
              end
            else begin
              {Do not do for extra description lines}
              iInsertIndex := lvLines.Items.Count;

              if (TKTLines[iPos].tlTransValueDiscountType = 255) then
              begin
                {Add MBD line}
                MBDTXLineRec := TKTLLine2TXLineRec(TKTLines[iPos]);
                MBDTXLineRec.bMBDLine := TRUE;
                MBDTXLineRec.bSerial := FALSE;
                NewItem := lvLines.Items.Add;
                For iLine := 1 to 5 do NewItem.SubItems.Add('');

                if MBDTXLineRec.TKTLRec.LineNo = 0 then MBDTXLineRec.TKTLRec.LineNo := lvLines.Items.Count+1;
                MBDTXLineRec.TKStockRec.Desc[1] := MBDTXLineRec.TKTLRec.Desc;
                MBDTXLineRec.sDesc := MBDTXLineRec.TKStockRec.Desc[1];
                MBDTXLineRec.iDiscount3Type := 255;
                TXLineRecToItem(MBDTXLineRec, NewItem);

                NewItem.Data := TTXLineInfo.Create(MBDTXLineRec);
                NewItem.ImageIndex := -1;

                UpdateDisplay;
              end else
              begin
                if (TKTLines[iPos].KitLink <> 0) and (Trim(TKTLines[iPos].StockCode) = '') then
                begin
                  {Add extra description lines of non-stock items}
                  NewTXLineRec := TKTLLine2TXLineRec(TKTLines[iPos]);
                  if bCurrItemIsNonStock then
                  begin
                    AddTXLine(lvLines, NewTXLineRec, TXRec, iInsertIndex, iStockFolio);
                    UpdateDisplay;
                  end;{if}
                  inc(iExtraDescLine);
                  TTXLineInfo(lvLines.Items[lvLines.Items.Count - iExtraDescLine].Data).TXLineRec.TKStockRec.Desc[iExtraDescLine] := TKTLines[iPos].Desc;

                  if bCurrItemIsNonStock then begin
                    with lvLines.Items[iInsertIndex] do begin
                      InitialiseTXLine(TTXLineInfo(Data).TXLineRec, 0);
                      TTXLineInfo(Data).TXLineRec.TKStockRec.Desc[1] := TKTLines[iPos].Desc;
                      TTXLineInfo(Data).TXLineRec.bDescLine := TRUE;
                      TTXLineInfo(Data).TXLineRec.sDesc := TKTLines[iPos].Desc; {.281}
                      SubItems[0] := TKTLines[iPos].Desc;
                      ImageIndex := -1;
                    end;{with}
                  end;{if}

                end else
                begin
                  {Sales Line}
                  if TKSysRec.CCDepts and (SetupRecord.CCDeptMode in [0,2])
                  and (TKTLines[iPos].tlTransValueDiscountType <> 255) then  // not an advanced discount desc line
                  begin
                    edCostCentre.Text := TKTLines[iPos].CC;
                    edDepartment.Text := TKTLines[iPos].Dep;
                    TXRec.sCostCentre := TKTLines[iPos].CC;
                    TXRec.sDepartment := TKTLines[iPos].Dep;
                  end;{if}

                  NewTXLineRec := TKTLLine2TXLineRec(TKTLines[iPos]);

                  {.298}
                  NewTXLineRec.bVATInclusive := (TKTLines[iPos].VatCode = 'M') and (Length(TKTLines[iPos].VATIncFlg) > 0) and (not Zerofloat(TKTLines[iPos].IncNetValue));
                  if NewTXLineRec.bVATInclusive then
                  begin
                  //  NewTXLineRec.TKTLRec.VATCode := 'I';
                    NewTXLineRec.TKStockRec.VATCode := 'I';
                  end;{if}

                  iStockFolio := NewTXLineRec.TKStockRec.StockFolio;

                  bCurrItemIsNonStock := Trim(TKTLines[iPos].StockCode) = '';
                  NewTXLineRec.bNonStock := bCurrItemIsNonStock and (TKTLines[iPos].Qty <> 0);
                  if NewTXLineRec.bNonStock then NewTXLineRec.sDesc := TKTLines[iPos].Desc;

                  // Get stock location record for this item / location
                  if (TKSysRec.MultiLocn > 0) and (Trim(NewTXLineRec.TKStockRec.StockCode) <> '') then
                  begin
                    with NewTXLineRec do begin
                      FillChar(TKStockLocRec,sizeOf(TKStockLocRec),#0);
                      pStockCode := StrAlloc(255);
                      pLocation := StrAlloc(255);
                      StrPCopy(pStockCode, TKStockRec.StockCode);
                      StrPCopy(pLocation, SetupRecord.DefStockLocation);
                      iStatus := EX_GETSTOCKLOC(@TKStockLocRec, SizeOf(TKStockLocRec), pStockCode, pLocation, FALSE);
                      if (iStatus <> 4) then ShowTKError('EX_GETSTOCKLOC', 70, iStatus);
                      StrDispose(pLocation);
                      StrDispose(pStockCode);
                    end;{with}
                  end;{if}

                  // Get the Stock Price Record for the stock item {.224}
                  if Trim(TKTLines[iPos].StockCode) <> '' then begin
                    with NewTXLineRec, TKStockPriceRec do begin
                      {gets the standard stock price}
                      StockCode := TKTLines[iPos].StockCode;
                      CustCode := TXRec.TKTXHeader.CustCode;
                      if TKSysRec.MultiLocn > 0 then LocCode := SetupRecord.DefStockLocation;
                      Currency := SetupRecord.TillCurrency;
                      Qty := TKTLines[iPos].Qty;
                      iStatus := Ex_CalcStockPrice(@TKStockPriceRec, SizeOf(TKStockPriceRec));
                      ShowTKError('Ex_CalcStockPrice', 80, iStatus);

                      // NF: 28/04/2008 {.288}{.289} Allows reading of new override prices
                      if (iStatus = 0) and (not zerofloat(TKStockPriceRec.Price - NewTXLineRec.rNetPrice))
                      and ZeroFloat(NewTXLineRec.rDiscount)
                      and (not bVATInclusive) {.299}
                      then
                      begin
                        NewTXLineRec.cDiscount := DT_OVERRIDE_PRICE;
  //                      NewTXLineRec.sDiscount := 'override';
                        SetDiscountStr(NewTXLineRec);

                        {.289}
    {                    NewTXLineRec.rDiscount := NewTXLineRec.rPrice;
                        NewTXLineRec.rPreEPOSDiscount := NewTXLineRec.rPrice;
                        NewTXLineRec.rNonDiscLineNetTotal := NewTXLineRec.rPrice;
    }
                        {.294} // NF: 06/11/2008
                        // To fix Case Reference CAS-84791-71PW5O IRIS:00841082-URGENT
                        NewTXLineRec.rDiscount := NewTXLineRec.rNetPrice;
                        NewTXLineRec.rPreEPOSDiscount := NewTXLineRec.rNetPrice;
                        NewTXLineRec.rNonDiscLineNetTotal := NewTXLineRec.rNetPrice;
                      end;{if}
                    end;{with}
                  end;{if}

                  // v6.50.313 07/10/2010 - Set Value (rOrigNetAmount) used to calc the total TX value, on VAT inclusive & Find TX
                  // Bug Fix for https://jira.iris.co.uk/browse/ABSEXCH-2539
                  if bFind and NewTXLineRec.bVATInclusive then
                  begin
                    NewTXLineRec.rOrigNetAmount := NewTXLineRec.rLineNetTotal;
                  end;{if}

                  AddTXLine(lvLines, NewTXLineRec, TXRec, iInsertIndex, iStockFolio, 0, FALSE);
                  UpdateDisplay;
                  iExtraDescLine := 1;

                end;{if}
              end;{if}
            end;{if}
          end;{if}
        end;{for}

        // Might have matched TXs....
        if (Copy(TXRec.TKTXHeader.OurRef,1,3) = 'SIN') or (Copy(TXRec.TKTXHeader.OurRef,1,3) = 'SJI')
        or (Copy(TXRec.TKTXHeader.OurRef,1,3) = 'SCR') or (Copy(TXRec.TKTXHeader.OurRef,1,3) = 'SJC') then begin

//          TXRec.rDepositsTaken := 0; {.221}
          rWrittenOffB4 := TXRec.rWrittenOff;

          // get payments from all SRC transactions that are matched to our TX
          iStatus := Ex_GetMatch(@TKMatchRec, SizeOf(TKMatchRec),pOurRef,0,B_GetGEq,FALSE);

          while (iStatus = 0) and (TKMatchRec.DebitRef = TXRec.TKTXHeader.OurRef) do begin

            // Only for financial matching
            if TKMatchRec.MatchType = 'A' then begin {.223}

              {Get SRC Lines}
              TXRec.rDepositsTaken := TXRec.rDepositsTaken + TKMatchRec.DebitVal; {.221}

              StrPCopy(pOurRef,TKMatchRec.CreditRef);
              iStatus2 := Ex_GetTrans(@LTKTXHeader, @TKTLines, SizeOf(LTKTXHeader), SizeOf(TKTLines), pOurRef, 0, B_GetEq, FALSE);
              ShowTKError('Ex_GetTrans', 20, iStatus2);
              For iPos := 1 to LTKTXHeader.LineCount do begin
                if TKTLines[iPos].Payment then begin
                  {Payment Line}
                  if (TKTLines[iPos].Desc = 'Discount (write-off)') then begin {.221}
                    TXRec.rWrittenOff := TXRec.rWrittenOff + ABS(TKTLines[iPos].NetValue) {.221}
                  end;{if} {.221}

  {                if (TKTLines[iPos].Desc = 'Discount (write-off)') then TXRec.rWrittenOff := TXRec.rWrittenOff + ABS(TKTLines[iPos].NetValue)
                  else TXRec.rDepositsTaken := TXRec.rDepositsTaken + TKMatchRec.DebitVal;}
  //                else TXRec.rDepositsTaken := TXRec.rDepositsTaken + TKTLines[iPos].NetValue;
                end;{if}
              end;{for}
            end;{if}

            {Get Next Match}
            iStatus := Ex_GetMatch(@TKMatchRec, SizeOf(TKMatchRec),pOurRef,0,B_GetNext,FALSE);

          end;{while}

          TXRec.rDepositsTaken := TXRec.rDepositsTaken - (TXRec.rWrittenOff - rWrittenOffB4); {.221}

        end;{if}

        if (Copy(TXRec.TKTXHeader.OurRef,1,3) = 'SOR') then begin

          // get payment from SRCs that have the correct SIN number in their

          // Find First SRC

          FillChar(LTKTXHeader, SizeOf(LTKTXHeader), #0);

          FillChar(TKTLines, SizeOf(TKTLines), #0);
          pYourRef := StrAlloc(255);
          StrPCopy(pYourRef, TXRec.TKTXHeader.OurRef);
          iStatus := Ex_GetTrans(@LTKTXHeader, @TKTLines, SizeOf(LTKTXHeader), SizeOf(TKTLines), pOurRef, 3, B_GetEq, FALSE);

          while (iStatus = 0) and (LTKTXHeader.YourRef = TXRec.TKTXHeader.OurRef) do begin
            if (Copy(LTKTXHeader.OurRef,1,3) = 'SRC') then begin {.221}
              // Figures out written off, and deposit amounts for all lines in this SRC
              For iPos := 1 to LTKTXHeader.LineCount do begin
                if TKTLines[iPos].Payment then begin
                  {Payment Line}
                  if (TKTLines[iPos].Desc = 'Discount (write-off)') then TXRec.rWrittenOff := TXRec.rWrittenOff + ABS(TKTLines[iPos].NetValue)
                  else TXRec.rDepositsTaken := TXRec.rDepositsTaken + TKTLines[iPos].NetValue;
                end;{if}
              end;{for}
            end;{if}

            iStatus := Ex_GetTrans(@LTKTXHeader, @TKTLines, SizeOf(LTKTXHeader), SizeOf(TKTLines), pOurRef, 3, B_GetNext, FALSE);
          end;{while}

          StrDispose(pOurRef);
        end;{if}

        {round 'em off}
        rDepositsTaken := Round(rDepositsTaken * 100) / 100;
        rVATIncTotal := Round(rVATIncTotal * 100) / 100;
        rWrittenOff := Round(rWrittenOff * 100) / 100;

        {NF: I hate floating point numbers}
        rTemp := (rDepositsTaken + rWrittenOff + TKTXHeader.DiscSetAm);
        rTemp := Round(rTemp * 100) / 100;

        {Set Mode}
        if not bFind then TenderMode := tmAdd
        else begin
          if rVATIncTotal > rTemp then TenderMode := tmEdit
          else TenderMode := tmView;
        end;{if}
      end
    else ShowTKError('Ex_GetTrans', 20, iStatus);
  end;{with}

  EnableDisable;

  // v6.50.312 07/10/2010 - Do not recalc vat when finding a transaction
  // Bug Fix for https://jira.iris.co.uk/browse/ABSEXCH-2662
  if not bFind then RecalcAllTXLines(TXRec, lvLines, FALSE);
  //RecalcAllTXLines(TXRec, lvLines, FALSE);

  RecalcTXTotals(TXRec, lvLines);
  UpdateDisplay;
  FillFormFromTXRec;
  RecalcColWidths;
  ScrollList;


  if Inv.Currency <> SetupRecord.TillCurrency then begin
    bClear := FALSE;
    sMessage := '';
    if bFind then
      begin
        case TenderMode of
          tmEdit : begin
            sMessage := 'The Transaction that you have found is in a different currency to that of the current till.'
            + #13#13 + 'This Transaction cannot be opened.';
            bClear := TRUE;
          end;

          tmView : sMessage := 'Warning : The Transaction that you have found is in a different currency to that of the current till.'
          + #13 + 'The information that you view for this transaction may be incorrect.';
        end;{case}
      end
    else begin
      sMessage := 'Warning : The Transaction that you are copying from is in a different currency to that of the current till.'
      + #13 + 'The values of the items in this transaction will not be converted.';
    end;{if}
    if sMessage <> '' then MyMsgBox(sMessage,mtWarning,[mbOK],mbOK,'Currency Mismatch');
    if bClear then ClearTX;
  end;{if}
end;

procedure TFrmTXHeader.btnDepositClick(Sender: TObject);
var
  NewActiveControl : TWinControl;
  bOK : boolean;
begin
  if TWinControl(Sender).Visible and TWinControl(Sender).Enabled then begin
{    if not CheckAllSerialNumbers then Exit;}
    NewActiveControl := ActiveControl;
    ActiveControl := btnDeposit;
    with TFrmDeposit.Create(Self), TXRec do begin
      try
        if lvLines.Items.Count > 0 then
        begin
          // Take Deposit
          Mode := fmTakeDeposit;
          edDeposit.Value := rDepositToTake;
          rOSAmount := rOutstanding;
          bOK := ShowModal = mrOK;
          if bOK then rDepositToTake := edDeposit.Value;
        end else
        begin
          // On Account
          Mode := fmOnAccount;
          edDeposit.Value := rDepositToTake;
          cbCardRefund.Checked := bCardRefund;
          rOSAmount := rOutstanding;
          bOK := ShowModal = mrOK;
          if bOK then
          begin
            rDepositToTake := edDeposit.Value;
            bCardRefund := bCommideaPlugInRunning and cbCardRefund.Checked;
          end;
        end;
      finally
        Release;
      end;{try}
    end;{with}
    ActiveControl := NewActiveControl;

    if bOK then btnTenderClick(sender);
  end;{if}
end;

function TFrmTXHeader.AskLogin : boolean;
begin
  Result := FALSE;
  case GetModuleLicence(modTrade, GetTCMEnterpriseDirectory) of

    luLicenced : begin

      // Do we have user profiles available to us ?
      EnhancedSecurity := GetModuleLicence(modEnhSec, GetTCMEnterpriseDirectory);
      if EnhancedSecurity = luError then ShowLicenceErrorMessage('Enhanced Security')
      else begin
        FrmLogin := TFrmLogin.Create(Self, FALSE);
        with FrmLogin do begin
          try
            Result := Showmodal = mrOK;
          finally
            Release;
          end;{try}
        end;{with}
      end;{if}
    end;

    luNotLicenced : ShowNotLicencedMessage('Trade Counter');

    luError : ShowLicenceErrorMessage('Trade Counter');

  end;{case}
end;

procedure TFrmTXHeader.btnCancelClick(Sender: TObject);
begin
  Screen.Cursor := crHourglass;
  Close;
end;

procedure TFrmTXHeader.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if TXRec.bAccountOK and (not bDontAskOnExit) then
    begin
      CanClose := FALSE;
      Case TenderMode of
        tmView : ClearTX;

        tmAdd : begin
          if (MyMsgBox('Are you sure that you want to cancel this transaction ?'
          ,mtConfirmation,[mbYes,mbNo],mbNo,'Cancel Transaction') = mrYes) then ClearTX;
        end;

        tmEdit : begin
          if (MyMsgBox('Are you sure that you want to close this transaction ?'
          ,mtConfirmation,[mbYes,mbNo],mbNo,'Close Transaction') = mrYes) then ClearTX;
        end
      end;{case}
    end
  else begin
    if not bForceClose then begin
      CanClose := not AskLogin;
      if not CanClose then InitialiseForm;
    end;{if}
  end;{if}

  if CanClose then begin
    // NF: 27/04/2007 Removed as file is not SQL compatible
//    Close_File(F[EposSysF]);
    if assigned(frmBackground) then
    begin
      frmBackground.Hide;
      frmBackground.Release;
    end;{if}
  end;{if}
  Screen.Cursor := crDefault;{.221}
end;

procedure TFrmTXHeader.InitialiseForm;
begin
  bBarCode := FALSE;
  TenderMode := tmAdd;
  bDontAskOnExit := FALSE;
  bIgnoreOnExits := FALSE;

  ClearTX;

//  FillChar(TXRec, SizeOf(TXRec),#0);
//  FillDefaults;

//  EnableDisable;
//  ActiveControl := edAccountCode;
end;


procedure TFrmTXHeader.FormShow(Sender: TObject);
begin
  lVATTotalTit.Caption := sVATText + ' Amount';
  btnDeposit.Visible := aAllowedTo[atTakeDeposits];
  btnCreateFrom.Visible := aAllowedTo[atCopyTransactions];
  btnFindTX.Visible := aAllowedTo[atFindTransactions];
  if btnFindTX.Visible then btnFindTX.Top := 567 - (48 * Ord(not btnCreateFrom.Visible));
  Screen.OnActiveFormChange := frmBackground.Refresh;
//  btnCancel.SetFocus;
//  application.processmessages;
//  edAccountCode.SetFocus;
//  application.processmessages;
//  ActiveControl := edAccountCode;

//  PostMessage(handle,WM_SysCommand,21,13);
  SendMessage(handle,WM_SysCommand,21,13);
end;

function TFrmTXHeader.CheckAllSerialNumbers : boolean;
var
  iLine : integer;
begin
  Result := TRUE;
  if TenderMode = tmAdd then begin
    with lvLines do begin
      For iLine := 0 to Items.Count - 1 do begin
        with TTXLineInfo(Items.Item[iLine].Data).TXLineRec do begin
          if bSerial and (not ZeroFloat(ABS(NoOfSerialNumbers(SerialNumbers, TKStockRec)) - ABS(TKTLRec.Qty)))
          then begin
            if AllowedTo(atLeaveSerialNosOutstanding) then
              begin
                Result := MyMsgBox('You have not entered the correct amount of serial numbers for this item : '
                + TKStockRec.Desc[1] + #13#13 + 'Do you wish to continue regardless ?'
                , mtInformation, [mbYes, mbNo], mbNo, 'Serial Numbers') = mrYes;
                exit;
              end
            else begin
              MyMsgBox('You have not entered the correct amount of serial numbers for this item : '
              + TKStockRec.Desc[1] + #13#13 + 'Please go back and enter the serial numbers.'
              , mtInformation, [mbOK], mbOK, 'Serial Numbers');
              Result := FALSE;
              exit;
            end;
          end;{if}
        end;{with}
      end;{for}
    end;{with}
  end;{if}
end;

function TFrmTXHeader.CheckAllBinNumbers : boolean;
var
  iStatus, iPos, iLine : integer;
  LTKBinRec : TBatchBinRec;
begin
  Result := TRUE;
  if TenderMode = tmAdd then begin
    with lvLines do begin
      For iLine := 0 to Items.Count - 1 do begin
        with TTXLineInfo(Items.Item[iLine].Data).TXLineRec do begin
          if TKStockRec.UsesBins and (not ZeroFloat(ABS(NoOfBinNumbers(BinNumbers, TKStockRec)) - ABS(TKTLRec.Qty)))
          then begin
            if AllowedTo(atLeaveBinsOutstanding) then
              begin
                Result := MyMsgBox('You have not entered the correct amount of Bin numbers for this item : '
                + TKStockRec.Desc[1] + #13#13 + 'Do you wish to continue regardless ?'
                , mtInformation, [mbYes, mbNo], mbNo, 'Bin Numbers') = mrYes;
                exit;
              end
            else begin
              MyMsgBox('You have not entered the correct amount of Bin numbers for this item : '
              + TKStockRec.Desc[1] + #13#13 + 'Please go back and enter the Bin numbers.'
              , mtInformation, [mbOK], mbOK, 'Bin Numbers');
              Result := FALSE;
              exit;
            end;
          end;{if}

          // check that the bin numbers selected by the user have not all been used.
          For iPos := 0 to BinNumbers.Count -1 do
          begin
            LTKBinRec := TBinInfo(BinNumbers.Objects[iPos]).TKBinRec;
            iStatus := Ex_GetMultiBin(@LTKBinRec, SizeOf(LTKBinRec), 0, B_GetEq, FALSE);
            if (iStatus <> 0) or ((LTKBinRec.brQty - LTKBinRec.brQtyUsed) <= 0) then
            begin
              MyMsgBox('The Bin numbers you have selected for this item (' + Trim(TKStockRec.StockCode)
              + ') are no longer available.' + #13#13
              + 'Please go back and re-select the Bin numbers.'
              , mtInformation, [mbOK], mbOK, 'Bin Numbers');
              ClearList(BinNumbers);
              Result := FALSE;
              Exit;
            end;
          end;{for}

        end;{with}
      end;{for}
    end;{with}
  end;{if}
end;

procedure TFrmTXHeader.FormDestroy(Sender: TObject);
begin

  // HM 31/01/02: Added code to switch application title
  Application.OnActivate   := nil;
  Application.OnDeactivate := nil;
  Application.OnMinimize   := nil;
  Application.OnRestore    := nil;

  if bToolkitOpen then Ex_CloseData;

{$IFDEF TCCU}  // Trade Counter Customisation
  KillCustomisation;
{$ENDIF}
end;

procedure TFrmTXHeader.ApplicationActive(Sender : TObject);
Begin
  Application.Title:='Trade Counter Module';
end;

procedure TFrmTXHeader.EntDeActivate(Sender : TObject);
Begin
  Application.Title := sUserName + ' - ' + sCurrCompName + ' - Trade Counter Module';
end;

function TFrmTXHeader.DoLayaway : boolean;
var
  iPos, iLine, iStatus : integer;

  function GetNextLayHeadFolio : integer;
  var
    iStatus : integer;
    sKey : Str255;
  begin
    iStatus := Find_Rec(B_GetLast, F[LayHeadF], LayHeadF, RecPtr[LayHeadF]^, LayHeadFolioK, sKey);
    if iStatus in [4,9] then Result := 1
    else Result := LayHead.lhFolioNo + 1;
  end;{GetNextLayHeadFolio}

Begin

//  FillTXRecFromForm;

  // Fill Layaway Header
  FillChar(LayHead,SizeOf(LayHead),#0);
  with LayHead, TXRec do begin
    lhFolioNo := GetNextLayHeadFolio;
    lhUserName := sUserName;
    lhAccountCode := TXRec.TKTXHeader.CustCode;
    lhAccountName := lCompanyName.Caption;
    lhCustomerName := TKTXHeader.LongYrRef;
    lhOrderNo := TKTXHeader.YourRef;
    lhAddress := AddrTyp(TKTXHeader.DAddr);
    lhCostCentre := sCostCentre;
    lhDepartment := sDepartment;
    lhTKTHRecord := TKTXHeader;

    // Items description
    lhItemsDesc := '';
    For iLine := 0 to lvLines.items.count - 1 do begin
      with TTXLineInfo(lvLines.items[iLine].data).TXLineRec do begin
        if iLine <> 0 then lhItemsDesc := lhItemsDesc + ', ';
        lhItemsDesc := lhItemsDesc + MoneyToStr(TKTLRec.Qty) +  ' * ' + Trim(TKStockRec.Desc[1]);
      end;{with}
    end;{for}

    lhSettDisc := TKTXHeader.DiscSetl;
    lhSettDiscDays := TKTXHeader.DiscDays;
    lhDepositToTake := rDepositToTake;
    lhDate := DateToStr8(SysUtils.Date);
    lhTime := TimeToStr6(Time);
    lhTillNo := iTillNo;
    lhValue := TXRec.rVATIncTotal;

    lhDummyChar := IDX_DUMMY_CHAR;
  end;{with}

  // Add Layaway Header
  iStatus := Add_Rec(F[LayHeadF],LayHeadF,RecPtr[LayHeadF]^,CurrKeyPath^[LayHeadF]);
  Report_BError(LayHeadF,iStatus);

  if iStatus = 0 then begin

    // Layaway Lines
    For iLine := 0 to lvLines.items.count - 1 do begin

      // Description Line ?
      if not TTXLineInfo(lvLines.items[iLine].data).TXLineRec.bDescLine then begin

        // Fill Layaway Line
        FillChar(LayLine,SizeOf(LayLine),#0);
        with LayLine, TTXLineInfo(lvLines.items[iLine].data).TXLineRec do begin
          llHeaderNo := LayHead.lhFolioNo;
          llLineNo := iLine + 1;
          llStockCode := TKTLRec.StockCode;
          For iPos := 1 to 6 do llDescription[iPos] := TKStockRec.Desc[iPos];

//          llPrice := rNetPrice;{.166}
          if Trim(TKTLRec.StockCode) = '' then llPrice := rPreEPOSDiscount{.225}
          else llPrice := rNetPrice;{.225}

          if bVATInclusive then
            begin
              llVATInclusive := 'Y';
              TKTLRec.IncNetValue := rPrice; {.226}
            end
          else llVATInclusive := 'N';

          llVATRate := TKTLRec.VATCode;
          llDiscType := cDiscount;
          llDiscAmount := rDiscAmount;
          llDiscount := rDiscount;
          llDiscDesc := sDiscount;

          llQuantity := TKTLRec.Qty;
          llSerialItem := bSerial;

          llDummyChar := IDX_DUMMY_CHAR;

          llListFolioNo := iListFolioNo;
          llBOMParentFolioNo := iBOMParentFolioNo;
          llBOMQtyUsed := rBOMQtyUsed;
          llBOM := bBOM;
          llKitLink := TKTLRec.KitLink;
          llTKTLRecord := TKTLRec;
          llBOMComponent := bBOMComponent;{.281}

          // Add Layaway Line
          iStatus := Add_Rec(F[LayLineF], LayLineF, RecPtr[LayLineF]^, CurrKeyPath^[LayLineF]);
          Report_BError(LayLineF, iStatus);

          if iStatus <> 0 then break;

          if bSerial and (Assigned(SerialNumbers)) and (SerialNumbers.Count > 0) then begin

            // store serial numbers
            For iPos := 0 to SerialNumbers.Count - 1 do begin
              with LaySerial, TSerialInfo(SerialNumbers.Objects[iPos]) do begin
                lsHeaderNo := LayHead.lhFolioNo;
                lsLineNo := llLineNo;
                lsBatch := bBatch;
                lsSerialNo := TKSerialRec.SerialNo;
                lsBatchNo := TKSerialRec.BatchNo;
                lsUsedInBatch := UsedInBatch;
                lsUsedInThisLine := UsedInThisLine;
                lsUsedElsewhere := UsedElsewhere;
                lsDummyChar := IDX_DUMMY_CHAR;
              end;{with}

              // Add Serial number record
              iStatus := Add_Rec(F[LaySerialF], LaySerialF, RecPtr[LaySerialF]^, CurrKeyPath^[LaySerialF]);
              Report_BError(LaySerialF, iStatus);

            end;{for}
          end;{if}

          if TKStockRec.UsesBins and (Assigned(BinNumbers)) and (BinNumbers.Count > 0) then begin

            // store Bin numbers
            For iPos := 0 to BinNumbers.Count - 1 do begin
              with LayBin, TBinInfo(BinNumbers.Objects[iPos]) do begin
                lbHeaderNo := LayHead.lhFolioNo;
                lbLineNo := llLineNo;
                lbBinCode := TKBinRec.brBinCode;
                lbUsedInBatch := UsedInBatch;
                lbUsedInThisLine := UsedInThisLine;
                lbUsedElsewhere := UsedElsewhere;
                lbDummyChar := IDX_DUMMY_CHAR;
              end;{with}

              // Add Bin number record
              iStatus := Add_Rec(F[LayBinF], LayBinF, RecPtr[LayBinF]^, CurrKeyPath^[LayBinF]);
              Report_BError(LayBinF, iStatus);

            end;{for}
          end;{if}
        end;{with}
      end;{if}
    end;{for}
  end;{if}

  Result := iStatus = 0;

end;


procedure TFrmTXHeader.btnLayawayClick(Sender: TObject);
begin
  if BtnLayaway.Enabled then begin
    if MyMsgBox('Are you sure you want to Layaway this transaction ?',mtConfirmation
    ,[mbYes, mbNo],mbNo,'Layaway Transaction', 7) = mrYes then begin

      if DoLayaway then begin
        ClearTX;
        {Go back to login, or new TX ?}
        if SetupRecord.AfterTender = atLogin then begin
          bDontAskOnExit := TRUE;
          Close;
        end;{if}
      end;{if}

    end;{if}
  end;{if}
end;

procedure TFrmTXHeader.btnRetrieveLayawayClick(Sender: TObject);
var
  frmLayaways : TfrmLayaways;
  pStockCode : PChar;
  iInsertIndex : integer;

  procedure RetrieveLayaway;
  var
    iPos, iTKStatus, iStatus, iFolioNo, iSerStatus, iHeadStatus, iLineStatus
    , iStockFolio : integer;
    sKey : Str255;
    TXLineRec : TTXLineRec;
    SerialInfo : TSerialInfo;
    BinInfo : TBinInfo;
    TKSerialRec : TBatchSerialRec;
    TKBinRec : TBatchBinRec;
    bBOMPrice{.281}, bFound : boolean;

    procedure FillTXRecFromLayaway;
    var
      iPos : integer;
    begin{FillTXRecFromLayaway}
      with TXRec, LayHead do begin
        TKTXHeader := lhTKTHRecord;
        if not SetupRecord.KeepOriginalLayawayDate
        then TKTXHeader.TransDate := DateToStr8(SysUtils.Date);
//        TKTXHeader.LongYrRef := lhCustomerName;
//        TKTXHeader.YourRef := lhOrderNo;
//        For iPos := 1 to 5 do TKTXHeader.DAddr[iPos] := lhAddress[iPos];
        sCostCentre := lhCostCentre;
        sDepartment := lhDepartment;

//        TKTXHeader.DiscSetl := lhSettDisc;
//        TKTXHeader.DiscDays := lhSettDiscDays;
        rDepositToTake := lhDepositToTake;

      end;{with}
    end;{FillTXRecFromLayaway}

    procedure FillBOMCompArrays;
    var
      iLine : integer;

      procedure AddBOMCompsTo(var BOMTXLineRec : TTXLineRec);
      var
        iLine : integer;
      begin{AddBOMCompsTo}
        with LvLines.Items do begin
          for iLine := 0 to Count -1 do begin
            with TTXLineInfo(Item[iLine].Data), TXLineRec do begin
              if TXLineRec.iBOMParentFolioNo = BOMTXLineRec.iListFolioNo then begin
                // Add FolioNumber to the BOMs List of Components
                SetLength(BOMTXLineRec.BOMComponents, length(BOMTXLineRec.BOMComponents) + 1);
                BOMTXLineRec.BOMComponents[length(BOMTXLineRec.BOMComponents) - 1]
                := TXLineRec.iListFolioNo;
              end;{if}
            end;{with}
          end;{for}
        end;{with}
      end;{AddBOMCompsTo}

    begin{FillBOMCompArrays}
      with LvLines.Items do begin
        for iLine := 0 to Count -1 do begin
          with TTXLineInfo(Item[iLine].Data), TXLineRec do begin
            if bBOM then AddBOMCompsTo(TXLineRec);
          end;{with}
        end;{for}
      end;{with}
    end;{FillBOMCompArrays}

  begin{RetrieveLayaway}

    bBOMPrice := FALSE;

    with frmLayaways do begin

      // Get Header record
      iFolioNo := TItemInfo(lvLayaways.selected.Data).ID;
      sKey := FullNomKey(iFolioNo) + IDX_DUMMY_CHAR;
      iHeadStatus := Find_Rec(B_GetEq, F[LayHeadF], LayHeadF, RecPtr[LayHeadF]^, LayHeadFolioK, sKey);

      if (iHeadStatus = 0) and (LayHead.lhFolioNo = iFolioNo) then begin

        // populate header
        edAccountCode.Text := LayHead.lhAccountCode;
        edAccountCodeExit(nil);
        FillTXRecFromLayaway;
        FillFormFromTXRec;

        // clear list
        lvLines.Items.Clear;

        // Get First TX Line
        sKey := FullNomKey(iFolioNo);
        iLineStatus := Find_Rec(B_GetGEq, F[LayLineF], LayLineF, RecPtr[LayLineF]^, LayLineK, sKey);

        while (iLineStatus = 0) and (LayLine.llHeaderNo = iFolioNo) do begin {.166}

//          FillChar(TXLineRec, SizeOf(TXLineRec),#0);
          InitialiseTXLine(TXLineRec);

          with TXLineRec do begin
            TKTLRec := LayLine.llTKTLRecord;
//            TKTLRec.StockCode := LayLine.llStockCode;
            bStockOK := TRUE;
            cDiscount := LayLine.llDiscType;

            rDiscount := LayLine.llDiscount;{.223}
            rDiscAmount := LayLine.llDiscAmount;{.223}
//            sDiscount := LayLine.llDiscDesc;{.223}

            rMultiBuyDisc := TKTLRec.tlMultiBuyDiscount;
            cMultiBuyDisc := TKTLRec.tlMultiBuyDiscountChr;

            {.303}
//            if cMultiBuyDisc = '%' then rMultiBuyDiscAmount := (rNetPrice * rMultiBuyDisc)
//            else rMultiBuyDiscAmount := rMultiBuyDisc;
            {.304}
            if cMultiBuyDisc = '%' then rMultiBuyDiscAmount := (rPreEPOSDiscount * rMultiBuyDisc)
            else rMultiBuyDiscAmount := rMultiBuyDisc;

            bMBDLine := (TKTLRec.tlTransValueDiscountType = 255) and (not ZeroFloat(TKTLRec.Qty));

            SetDiscountStr(TXLineRec);

            TKTLRec.Qty := LayLine.llQuantity;
            bSerial := LayLine.llSerialItem;
            iListFolioNo := LayLine.llListFolioNo;
            iBOMParentFolioNo := LayLine.llBOMParentFolioNo;
            rBOMQtyUsed := LayLine.llBOMQtyUsed;
            bBOM := LayLine.llBOM;
            bBOMComponent := LayLine.llBOMComponent;{.281}

//            TKTLRec.KitLink := LayLine.llKitLink;

            if LayLine.llStockCode = '' then
            begin
              if bMBDLine then
              begin
                // MBD Line
                FillChar(TKStockRec, SizeOf(TKStockRec),#0);
                TKStockRec.Desc[1] := LayLine.llDescription[1];
                TXLineRec.sDesc := TKStockRec.Desc[1];
              end else
              begin
                // Non-Stock Line
                // Fill Extra fields for Non Stock Items
                FillChar(TKStockRec, SizeOf(TKStockRec),#0);
                For iPos := 1 to 6 do TKStockRec.Desc[iPos] := LayLine.llDescription[iPos];
                TXLineRec.sDesc := TKStockRec.Desc[1];{.233}
                TXLineRec.bNonStock := TRUE;{.233}
                rPrice := LayLine.llPrice;
                bVATInclusive := LayLine.llVATInclusive = 'Y';
                TKTLRec.VATCode := LayLine.llVATRate;

//                RecalcNonStockPrice(TXLineRec, LayLine.llPrice, LayLine.llQuantity
//                , LayLine.llVATRate, LayLine.llVATRate = 'I')

                {.226}
{                RecalcNonStockPrice(TXLineRec, LayLine.llPrice
                , LayLine.llQuantity, LayLine.llVATRate, bVATInclusive)}

                {.226}
                if bVATInclusive then RecalcNonStockPrice(TXLineRec, TKTLRec.IncNetValue
                , LayLine.llQuantity, LayLine.llVATRate, bVATInclusive)
                else RecalcNonStockPrice(TXLineRec, LayLine.llPrice
                , LayLine.llQuantity, LayLine.llVATRate, bVATInclusive)

              end;{if}
            end else
            begin
              // Stock Line
              // add line to listview
              pStockCode := StrAlloc(17);
              StrPCopy(pStockCode,LayLine.llStockCode);
              iStatus := Ex_GetStock(@TXLineRec.TKStockRec, SizeOf(TKStockRec)
              , pStockCode, 0, B_GetEq, FALSE);
              StrDispose(pStockCode);
              ShowTKError('Ex_GetStock', 30, iStatus);

              if bBOM then bBOMPrice := TXLineRec.TKStockRec.StKitPrice;{.281}

              {.226}
              bVATInclusive := LayLine.llVATInclusive = 'Y';

              if bVATInclusive then
              begin
                TKTLRec.VATCode := 'I';
                TKStockRec.VATCode := 'I';

                // NF: 23/03/2011 - v6.70.315
                // fix for https://jira.iris.co.uk/browse/ABSEXCH-10490
                TXLineRec.TKStockRec.SVATIncFlg := LayLine.llTKTLRecord.VATIncFlg;
              end;{if}
//              rNonDiscLineNetTotal := 0;
//              rPreEPOSDiscount := LayLine.llPrice;
//              rNetPrice := LayLine.llPrice;
//              rTotalLineVATAmount := 0;
//              rVATAmountForOne := 0;
//              rPrice := TKTLRec.IncNetValue;
//              rLineTotal := 0;
//              rLineNetTotal := 0;

              // serial number items
              if TXLineRec.bSerial then begin
                // Create String List
                if Assigned(TXLineRec.SerialNumbers) then
                begin
                  ClearList(TXLineRec.SerialNumbers);
                  TXLineRec.SerialNumbers.Free;
                end;
                TXLineRec.SerialNumbers := TStringList.Create;

                // look for serial number items
                sKey := FullNomKey(iFolioNo) + FullNomKey(LayLine.llLineNo) + IDX_DUMMY_CHAR;
                iSerStatus := Find_Rec(B_GetEq, F[LaySerialF], LaySerialF, RecPtr[LaySerialF]^, lsFindSerialK, sKey);

                // get all serial numbers for this TX Line
                while (iSerStatus = 0) and (LaySerial.lsHeaderNo = iFolioNo)
                and (LaySerial.lsLineNo = LayLine.llLineNo) do begin

                  // look through serial number records in the toolkit
                  bFound := FALSE;
                  FillChar(TKSerialRec,SizeOf(TKSerialRec),#0);
                  TKSerialRec.StockCode := LayLine.llStockCode;
                  iTKStatus := Ex_GetSerialBatch(@TKSerialRec, SizeOf(TKSerialRec), B_GetGEq);

                  while (TKSerialRec.StockCode = LayLine.llStockCode) and (iTKStatus = 0)
                  and (bFound = FALSE) do begin
                    if (TKSerialRec.SerialNo = LaySerial.lsSerialNo)
                    or (LaySerial.lsBatch and (TKSerialRec.BatchNo = LaySerial.lsBatchNo)) then begin
                      // found correct serial batch record
                      bFound := TRUE;
                    end;{if}

                    if not bFound then begin
                      {next record}
                      FillChar(TKSerialRec,SizeOf(TKSerialRec),#0);
                      TKSerialRec.StockCode := LayLine.llStockCode;
                      iTKStatus := Ex_GetSerialBatch(@TKSerialRec, SizeOf(TKSerialRec), B_GetNext);
                    end;{if}
                  end;{while}

                  if bFound then begin

                    SerialInfo := TSerialInfo.CreateFrom(TKSerialRec,0);

                    with LaySerial, SerialInfo do begin
                      bBatch := lsBatch;
                      UsedInBatch := lsUsedInBatch;
                      UsedInThisLine := lsUsedInThisLine;
                      UsedElsewhere := lsUsedElsewhere;

                      TXLineRec.SerialNumbers.AddObject(GetSerialDescription(SerialInfo, (lsUsedInBatch + lsUsedInThisLine > 0)), SerialInfo);
                    end;{with}

                  end;{if}

                  iSerStatus := Find_Rec(B_GetNext, F[LaySerialF], LaySerialF, RecPtr[LaySerialF]^, lsFindSerialK, sKey);

                end;{while}
              end;{if}

              // Multi Bin items
              if TXLineRec.TKStockRec.UsesBins then begin
                // Create String List
                if Assigned(TXLineRec.BinNumbers) then
                begin
                  ClearList(TXLineRec.BinNumbers);
                  TXLineRec.BinNumbers.Free;
                end;{if}
                TXLineRec.BinNumbers := TStringList.Create;

                // look for Bin number items
                sKey := FullNomKey(iFolioNo) + FullNomKey(LayLine.llLineNo) + IDX_DUMMY_CHAR;
                iSerStatus := Find_Rec(B_GetEq, F[LayBinF], LayBinF, RecPtr[LayBinF]^, lbFindBinK, sKey);

                // get all Bin numbers for this TX Line
                while (iSerStatus = 0) and (LayBin.lbHeaderNo = iFolioNo)
                and (LayBin.lbLineNo = LayLine.llLineNo) do begin

                  // look through Bin number records in the toolkit
                  bFound := FALSE;
                  FillChar(TKBinRec,SizeOf(TKBinRec),#0);
                  iStockFolio := GetStockFolioFromCode(LayLine.llStockCode);
                  TKBinRec.brStockFolio := iStockFolio;
                  iTKStatus := Ex_GetMultiBin(@TKBinRec, SizeOf(TKBinRec), 1, B_GetGEq, FALSE);

                  while (TKBinRec.brStockFolio = iStockFolio) and (iTKStatus = 0)
                  and (bFound = FALSE) do begin
                    if (TKBinRec.brBinCode = LayBin.lbBinCode)
                    then begin
//                    or (LayBin.lsBatch and (TKBinRec.BatchNo = LayBin.lsBatchNo)) then begin
                      // found correct Bin batch record
                      bFound := TRUE;
                    end;{if}

                    if not bFound then begin
                      {next record}
                      FillChar(TKBinRec,SizeOf(TKBinRec),#0);
                      TKBinRec.brStockFolio := iStockFolio;
                      iTKStatus := Ex_GetMultiBin(@TKBinRec, SizeOf(TKBinRec), 1, B_GetNext, FALSE);
                    end;{if}
                  end;{while}

                  if bFound then begin

                    BinInfo := TBinInfo.CreateFrom(TKBinRec,0);

                    with LayBin, BinInfo do begin
//                      bBatch := lsBatch;
                      UsedInBatch := lbUsedInBatch;
                      UsedInThisLine := lbUsedInThisLine;
                      UsedElsewhere := lbUsedElsewhere;

                      TXLineRec.BinNumbers.AddObject(GetBinDescription(BinInfo, (lbUsedInBatch + lbUsedInThisLine > 0)), BinInfo);
                    end;{with}

                  end;{if}

                  iSerStatus := Find_Rec(B_GetNext, F[LayBinF], LayBinF, RecPtr[LayBinF]^, lbFindBinK, sKey);

                end;{while}
              end;{if}

              // MBD Lines
{              if not ZeroFloat(TXLineRec.rMultiBuyDisc) then
              begin
                // Create String List
                if Assigned(TXLineRec.MBDDescLines) then
                begin
                  ClearList(TXLineRec.MBDDescLines);
                  TXLineRec.MBDDescLines.Free;
                end;{if}
{                TXLineRec.MBDDescLines := TStringList.Create;
              end;{if}

//              CalcStockPrice(TXRec, TXLineRec);
              if TXLineRec.bbomcomponent and bBOMPrice then {.281} // Do not work out the price for BOM components whose BOM have the "Price" flag ticked on the Build tab of the stock window
              else CalcStockPrice(TXRec, TXLineRec, FALSE); {.224}

              iStockFolio := TXLineRec.TKStockRec.StockFolio;

            end;{if}
          end;{with}

          iInsertIndex := lvLines.Items.Count;
          AddTXLine(lvLines, TXLineRec, TXRec, iInsertIndex, iStockFolio);
          UpdateDisplay;
          EnableDisable;
          RecalcColWidths;
          ScrollList;

          // Get Next TX Line
          iLineStatus := Find_Rec(B_GetNext, F[LayLineF], LayLineF, RecPtr[LayLineF]^, LayLineK, sKey);

        end;{while} {.166}

        FillBOMCompArrays;

        DeleteLayaway(iFolioNo);

      end;{if}

      {.281}
      // Populate UDF4 with the new Till Number.
      if not TXRec.bNonTCMTX
      then TXRec.TKTXHeader.DocUser4 := 'EPOS' + PadString(psLeft,IntToStr(iTillNo),'0',2) + ':' + sTillName;

    end;{with}
  end;{RetrieveLayaway}

begin{btnRetrieveLayawayClick}

  // layaway current tx ?
  if (lvLines.Items.Count > 0) and (btnAdd.Enabled) then begin
    if MyMsgBox('Do you want to Layaway your current transaction ?',mtConfirmation
    ,[mbYes, mbNo],mbNo,'Layaway Transaction') = mrYes then begin
      if DoLayaway then ClearTX;
    end;{if}
  end;{if}

  // show layaway list
  frmLayaways := TfrmLayaways.Create(Self);
  with frmLayaways do begin
    try
      if showmodal = mrOK then RetrieveLayaway
      else begin
        if edAccountCode.Enabled then edAccountCode.SetFocus;
      end;{if}
    finally
      release;
    end;{try}
  end;{with}

end;

procedure TFrmTXHeader.FillDefaults;
begin
  if SetupRecord.UseDefAccCode = 1 then begin
    edAccountCode.Text := SetupRecord.DefaultAccountCode;
//    edAccountCodeExit(nil);
    ActiveControl := edAccountCode;
  end;{if}

  if SetupRecord.CCDeptMode = 2 then begin
    edCostCentre.Text := SetupRecord.DefCostCentre;
    edDepartment.Text := SetupRecord.DefDepartment;

    {.232}
    TXRec.sCostCentre := SetupRecord.DefCostCentre;
    TXRec.sDepartment := SetupRecord.DefDepartment;
  end;{if}
end;

procedure TFrmTXHeader.btnReLoginClick(Sender: TObject);
var
  TempFrmLogin : TFrmLogin;
  sPreviousUserName : string;
begin
  sPreviousUserName := sUserName;
  TempFrmLogin := TFrmLogin.Create(Self, TRUE);
  with TempFrmLogin do begin
    try
      if Showmodal = mrOK then begin
        TXRec.sOverrideUserName := sUserName;
        sUserName := sPreviousUserName;
      end;{if}
    finally
      Release;
    end;{try}
  end;{with}
end;
{
function TFrmTXHeader.GetNextListFolioNo : integer;
begin
  Result := iNextListFolioNo;
  inc(iNextListFolioNo);
end;}
(*
procedure TFrmTXHeader.CustomButtonClick(Sender: TObject; BtnHandlerId : integer);
begin
  {$IFDEF TCCU}  // Trade Counter Customisation
    // Check to see if the event has been enabled by a Plug-In
    If TWincontrol(Sender).Visible And TradeCustomisation.GotEvent(twiTransaction, BtnHandlerId) Then Begin
      // Update EventData with current data values
      TradeCustomisation.EventDataO.Assign (Self.Handle, twiTransaction, BtnHandlerId
      , TXRec, lvLines, TKLocationRecord, Self);

      // Execute the Hook Point Event
      TradeCustomisation.ExecuteEvent;

      // Check the Plug-In changed something
      with TradeCustomisation.EventDataO do begin
        if DataChanged Then Begin
          // Update form with changes
          TXRec := LTXRec;
          CopyListViewItems(LListView.Items, lvLines.Items);
          FillFormFromTXRec;
          UpdateDisplay;
        end;{if}
      end;{with}
    end; { If TradeCustomisation.GotEvent... }
  {$ENDIF}
end;
*)
procedure TFrmTXHeader.HOOK_TXHeadCustomButtonClick(Sender: TObject);
var
  CurrentLineRec : TTXLineRec;
begin
  {$IFDEF TCCU}  // Trade Counter Customisation
    // Check to see if the event has been enabled by a Plug-In
    If TWincontrol(Sender).Visible And TradeCustomisation.GotEvent(twiTransaction, TWincontrol(Sender).Tag) Then Begin

      if Assigned(lvLines.Selected) then CurrentLineRec := TTXLineInfo(lvLines.Selected.Data).TXLineRec
      else FillChar(CurrentLineRec, SizeOf(CurrentLineRec), #0);

      // Update EventData with current data values
      TradeCustomisation.EventDataO.Assign(Self.Handle, twiTransaction, TWincontrol(Sender).Tag
      , TXRec, lvLines, TKLocationRecord, CurrentLineRec, TKPayLines, Self);

      // Execute the Hook Point Event
      TradeCustomisation.ExecuteEvent;

      // Check the Plug-In changed something
      with TradeCustomisation.EventDataO do begin
        if DataChanged Then Begin
          // Update form with changes
          TXRec := LTXRec;
          CopyListViewItems(LListView.Items, lvLines.Items);
          FillFormFromTXRec;
          UpdateDisplay;
        end;{if}
      end;{with}
    end; { If TradeCustomisation.GotEvent... }
  {$ENDIF}
end;

procedure TFrmTXHeader.edAddress1Change(Sender: TObject);
begin
  TXRec.TKTXHeader.DAddr[1] := edAddress1.Text;
end;

procedure TFrmTXHeader.edAddress2Change(Sender: TObject);
begin
  TXRec.TKTXHeader.DAddr[2] := edAddress2.Text;
end;

procedure TFrmTXHeader.edAddress3Change(Sender: TObject);
begin
  TXRec.TKTXHeader.DAddr[3] := edAddress3.Text;
end;

procedure TFrmTXHeader.edAddress4Change(Sender: TObject);
begin
  TXRec.TKTXHeader.DAddr[4] := edAddress4.Text;
end;

procedure TFrmTXHeader.edAddress5Change(Sender: TObject);
begin
  TXRec.TKTXHeader.DAddr[5] := edAddress5.Text;
end;

procedure TFrmTXHeader.edPostcodeChange(Sender: TObject);
begin
  TXRec.TKTXHeader.thDeliveryPostcode := edPostcode.Text;
end;

procedure TFrmTXHeader.edCustNameChange(Sender: TObject);
begin
  TXRec.TKTXHeader.LongYrRef := edCustName.Text;
end;

procedure TFrmTXHeader.edOrderNoChange(Sender: TObject);
begin
  TXRec.TKTXHeader.YourRef := edOrderNo.Text;
end;

procedure TFrmTXHeader.UpdateDisplay;
begin
  with TXRec do begin
    lNetTotal.Caption := sCurrencySym + ' ' + MoneyToStr(rNetTotal);
    lVatTotal.Caption := sCurrencySym + ' ' + MoneyToStr(TKTXHeader.InvVat);
    lVATIncTotal.Caption := sCurrencySym + ' ' + MoneyToStr(rVATIncTotal);
  end;{with}
end;


procedure TFrmTXHeader.Button1Click(Sender: TObject);
begin
  showmessage(MoneyToStr(TTXLineInfo(LvLines.Items.Item[LvLines.ItemIndex].Data).TXLineRec.tktlrec.netvalue));
end;

function TFrmTXHeader.NotGoingToOneOfTheButtonsToIgnore : boolean;
begin
  Result := (ActiveControl <> btnCustom1) and (ActiveControl <> btnCustom2)
  and (ActiveControl <> btnCancel) and (ActiveControl <> nil)
  and (ActiveControl <> btnRetrieveLayaway) and (ActiveControl <> btnCreateFrom)
  and (ActiveControl <> btnFindTX) and (ActiveControl <> btnFindAcc)
  and (ActiveControl <> btnCustom1) and (ActiveControl <> btnCustom2);
end;



procedure TFrmTXHeader.FormActivate(Sender: TObject);
begin
  ActiveControl := edAccountCode;
end;

procedure TFrmTXHeader.lvLinesChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  EnableDisable;
end;

procedure TFrmTXHeader.MBDChanged(Sender: TObject);
begin
  // dummy
end;

end.
