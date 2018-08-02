unit Tender;

{ nfrewer440 16:28 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs
  , EPOSProc, StrUtil, ExtCtrls, StdCtrls, IAeverButton, CardDet, TEditVal
  , EPOSCnst, CalcVBD, TXRecs, TTDF, TTDCalcTCM, DLLInt, GlobType, ETDateU
  , DLLInc{, TXHead};

{$I EXDLLBT.INC}

type
  TTXType = (ttOrder, ttPayedOff, ttPartPayment);

  TFrmTender = class(TForm)
    btnCash: TIAeverButton;
    btnCard: TIAeverButton;
    btnCheque: TIAeverButton;
    panCash: TPanel;
    panCard: TPanel;
    panCheque: TPanel;
    panLeftOnAcc: TPanel;
    Label2: TLabel;
    Shape1: TShape;
    Label3: TLabel;
    Shape2: TShape;
    Label4: TLabel;
    Shape3: TShape;
    lOSDesc: TLabel;
    btnTender: TIAeverButton;
    panChange: TPanel;
    lChange: TLabel;
    edCash: TCurrencyEdit;
    edCard: TCurrencyEdit;
    edCheque: TCurrencyEdit;
    Shape4: TShape;
    lLeftOnAccount: TLabel;
    btnSettDiscount: TIAeverButton;
    btnCancel: TIAeverButton;
    btnPrinter: TIAeverButton;
    panPrint: TPanel;
    Label5: TLabel;
    btnReprint: TIAeverButton;
    btnTransDiscount: TIAeverButton;
    panOustanding: TPanel;
    lOutstanding: TLabel;
    lOS: TLabel;
    panDeposit: TPanel;
    lDep2: TLabel;
    lToBeTaken: TLabel;
    panDiscounts: TPanel;
    panAfterDiscount: TPanel;
    lVATAmountTit: TLabel;
    lAmountTit: TLabel;
    lVAT: TLabel;
    lAmount: TLabel;
    lTransDiscount: TLabel;
    lValueDiscount: TLabel;
    lVBDTit: TLabel;
    shDep: TShape;
    lNextVBDTit: TLabel;
    Bevel1: TBevel;
    lVBD: TLabel;
    panSettDiscount: TPanel;
    lSettAmount: TLabel;
    lSettDiscount: TLabel;
    shSettDisc: TShape;
    panMoneyTaken: TPanel;
    Label6: TLabel;
    lDeposits: TLabel;
    panOrigNetAmount: TPanel;
    lNet: TLabel;
    lOrigNetTit: TLabel;
    lNetAfterDisc: TLabel;
    Label8: TLabel;
    lTTDPercent: TLabel;
    procedure btnTenderClick(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnCashClick(Sender: TObject);
    procedure btnCardClick(Sender: TObject);
    procedure btnChequeClick(Sender: TObject);
    procedure btnAccountClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure edExit(Sender: TObject);
    procedure edChange(Sender: TObject);
    procedure btnSettDiscountClick(Sender: TObject);
    procedure btnReprintClick(Sender: TObject);
    procedure btnPrinterClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnTransDiscountClick(Sender: TObject);
  private
    aPayedBy : array[pbCash..pbAccount] of boolean;
    bEditChanging : boolean;
    function TotaliseEdits : real;
    function StoreTransaction(var sTXRefNo : string9; iResult : integer; var iFolioNum : integer) : Integer;
    // NF: 22/05/2008 {.290} New Custom Event for Tomlinson Parbands
//    Function PrintTX(sTXRefNo : string; iFolioNum : integer) : integer;
    Function PrintTX(sTXRefNo : string; iFolioNum, iCopies : integer) : integer;
    procedure EnableDisable;
    function AddNotes : SmallInt;
    function ModifyNotes(sDoc : string) : SmallInt;
    function StoreNote(TKTXNotes : TBatchNotesRec; iLineNo : byte; sLine : string; bInsert : Boolean): smallint;
    function HOOK_TenderBeforePrint(var iCopies : integer) : boolean; // NF: 22/05/2008 {.290} New Custom Event for Tomlinson Parbands
    Procedure ApplyVBD;
  public
    DepositMode : TDPFormMode;
    procedure PopulateForm(var TheTXRec: TTXRec);
  end;

{var
  FrmTender: TFrmTender;}

implementation
uses
{$IFDEF TCCU}  // Trade Counter Customisation
  CustIntU, EnterpriseTrade_TLB,
{$ENDIF}
  CalcPric, EPOSKey, {NeilProc,} MathUtil, APIUtil, TKUtil, UseDllU, Login
  , TXHead, EPOSComn, VarConst, RPDevice, GfxUtil, ETMiscU, SerialPrc
  , MultiBinPrc;

{$R *.DFM}

procedure TFrmTender.btnTenderClick(Sender: TObject);
var
  iResult : byte;
//  iCont, iPanCont : integer;
  iCopies, iCont, iPanCont : integer; // NF: 22/05/2008 {.290} New Custom Event for Tomlinson Parbands
  bOKIt : boolean;
  FrmCardDetails : TFrmCardDetails;
  Buttons : TMsgDlgButtons;
  OldCustType : TCustType;
  sTXRefNo : String9;
  sLeftOnAccount : string;

  procedure RoundChange;
  var
    iChangePence, iRoundToPence, iRemainder : integer;
    bRoundDown : boolean;
  begin{RoundChange}
    iChangePence := Round(TXRec.rChange * 100);
    iRoundToPence := Round(SetupRecord.RoundChangeTo * 100);
    iRemainder := iChangePence MOD iRoundToPence;
    if iRemainder <> 0 then begin
      {rounding needs to occur}
      bRoundDown := iRemainder > (iRoundToPence / 2);
      TXRec.rChange := (((iChangePence DIV iRoundToPence) + Ord(bRoundDown))
      * iRoundToPence) / 100;
      {if bRoundDown then }TXRec.rWrittenOff := Round((TXRec.rChange * 100) - iChangePence) / 100;
    end;{if}
  end;{RoundChange}

  function HOOK_OnFireCashDrawer : boolean;
  var
    CurrentLineRec : TTXLineRec;
  begin{HOOK_OnFireCashDrawer}
    Result := FALSE;
    {$IFDEF TCCU}  // Trade Counter Customisation
      // Check to see if the event has been enabled by a Plug-In
      if TradeCustomisation.GotEvent(twiTender, hpOnFireCashDrawer) then begin

        FillChar(CurrentLineRec, SizeOf(CurrentLineRec), #0);

        // Update EventData with current data values
        TradeCustomisation.EventDataO.Assign(Self.Handle, twiTender, hpOnFireCashDrawer
        , TXRec, FrmTXHeader.lvLines, TKLocationRecord, CurrentLineRec, TKPayLines, FrmTXHeader);

        // Execute the Hook Point Event
        TradeCustomisation.ExecuteEvent;

        Result := TRUE;

      end; { If TradeCustomisation.GotEvent... }
    {$ENDIF}
  end;{HOOK_OnFireCashDrawer}

  Procedure CreatePaymentLines;
  var
    iLine : integer;
    sCC, sDept : string3;
    BlankTXLine : TTXLineRec;
  begin
    InitialiseTXLine(BlankTXLine);
    with TXRec do begin
      FillChar(TKPayLines,SizeOf(TKPayLines),#0);
      For iLine := Succ(Ord(Low(TPayedBy))) to Ord(High(TPayedBy)) do begin
        if not ZeroFloat(arPayments[TPayedBy(iLine - 1)]) then begin

          GetCCDept(sCC, sDept, BlankTXLine);

//          TKPayLines[iLine].StockCode := 'Payment';
          TKPayLines[iLine].StockCode := 'TC' + FormatDateTime('dd/mm/yy',Date);

          TKPayLines[iLine].Desc := TPayedByToText(TPayedBy(iLine - 1),-1);
          TKPayLines[iLine].Currency := SetupRecord.TillCurrency;
          TKPayLines[iLine].CoRate := TKTXHeader.CoRate;
          TKPayLines[iLine].VatRate := TKTXHeader.VatRate;
          TKPayLines[iLine].LineNo := (TKTXHeader.LineCount + iLine) * 2;
          TKPayLines[iLine].LineDate := TKTXHeader.TransDate;
          TKPayLines[iLine].CC := sCC;
          TKPayLines[iLine].Dep := sDept;

          if TPayedBy(iLine - 1) <> pbCard
          then TKPayLines[iLine].NomCode := SetupRecord.MOPNomCodes[TPayedBy(iLine - 1)];

          TKPayLines[iLine].Qty := 1;
          TKPayLines[iLine].QtyMul := 1;
          TKPayLines[iLine].Payment := TRUE;

          if (not ZeroFloat(rChange)) and (TPayedBy(iLine - 1) = pbCash) then TKPayLines[iLine].NetValue := arPayments[TPayedBy(iLine - 1)] - rChange
          else TKPayLines[iLine].NetValue := arPayments[TPayedBy(iLine - 1)];

{          if TPayedBy(iLine) = pbCard then begin
            TKPayLines[iLine].LineUser1 := asCardDetails[1];
            TKPayLines[iLine].LineUser2 := asCardDetails[2];
            TKPayLines[iLine].LineUser3 := asCardDetails[3];
            TKPayLines[iLine].LineUser4 := asCardDetails[4];
          end;{if}
        end;{if}
      end;{for}
    end;{with}
  end;{CreatePaymentLines}

  function HOOK_TenderOnTender : boolean;
  var
    CurrentLineRec : TTXLineRec;

    Procedure SetPickedQtyOnAllLines(bPicked : boolean);
    var
      iLine : integer;
    begin{SetPickedQtyOnAllLines}
      with FrmTXHeader.LvLines do begin
        For iLine := 0 to Items.Count -1 do begin
          with TTXLineInfo(Items.Item[iLine].Data).TXLineRec do begin
            if bPicked then TKTLRec.QtyPick := TKTLRec.Qty
            else TKTLRec.QtyPick := 0;
          end;{with}
        end;{for}
      end;{with}
    end;{SetPickedQtyOnAllLines}

  begin{HOOK_TenderOnTender}
    Result := TRUE;
    {$IFDEF TCCU}  // Trade Counter Customisation
      // Check to see if the event has been enabled by a Plug-In
      if TradeCustomisation.GotEvent(twiTender, hpTenderOnTender) then begin

        FillChar(CurrentLineRec, SizeOf(CurrentLineRec), #0);

        // Update EventData with current data values
        TradeCustomisation.EventDataO.Assign(Self.Handle, twiTender, hpTenderOnTender
        , TXRec, FrmTXHeader.lvLines, TKLocationRecord, CurrentLineRec, TKPayLines, FrmTXHeader);

        TradeCustomisation.EventDataO.aLongResult[1] := SetupRecord.TransactionType;
        TradeCustomisation.EventDataO.aBoolResult[1] := TRUE;

        // Execute the Hook Point Event
        TradeCustomisation.ExecuteEvent;

        // Set the Transaction type according to the value in LongResult[1]
        SetupRecord.TransactionType := TradeCustomisation.EventDataO.aLongResult[1];

        // Set Result to aBoolResult[1] - Do we allow the tender process to continue
        Result := TradeCustomisation.EventDataO.aBoolResult[1];

        SetPickedQtyOnAllLines(SetupRecord.TransactionType = TX_PICKED_SORs);

      end; { If TradeCustomisation.GotEvent... }
    {$ENDIF}
  end;{HOOK_TenderOnTender}

  function HOOK_OnShowChange : boolean;
  var
    CurrentLineRec : TTXLineRec;
  begin{HOOK_OnShowChange}
    Result := FALSE;
    {$IFDEF TCCU}  // Trade Counter Customisation
      // Check to see if the event has been enabled by a Plug-In
      if TradeCustomisation.GotEvent(twiTender, hpTenderOnShowChange) then begin

        FillChar(CurrentLineRec, SizeOf(CurrentLineRec), #0);

        // Update EventData with current data values
        TradeCustomisation.EventDataO.Assign(Self.Handle, twiTender, hpTenderOnShowChange
        , TXRec, FrmTXHeader.lvLines, TKLocationRecord, CurrentLineRec, TKPayLines, FrmTXHeader);

        // Execute the Hook Point Event
        TradeCustomisation.ExecuteEvent;

      end; { If TradeCustomisation.GotEvent... }
    {$ENDIF}
  end;{HOOK_OnShowChange}

begin
  if btnTender.Enabled then ActiveControl := btnTender;
  if btnTender.Enabled then begin
    ActiveControl := btnTender;
    if btnTender.Caption = 'Tender' then
      begin
        {Tender}

        if HOOK_TenderOnTender then
        begin

  {        case DepositMode of
            fmTakeDeposit : begin
            fmOnAccount : begin
              StoreSRC;
            end;
          end;{case}

          with TXRec do begin
            if (DepositMode = fmOnAccount) or (not ZeroFloat(rOutstanding)) or (ZeroFloat(rOutstanding)
            and (MyMsgBox('You are about to store a transaction with a zero value.' + #13#13
            + 'Are you sure you want to do this ?',mtConfirmation,[mbYes,mbNo],mbNo,'Zero Transaction') = mrYes)) then begin
              {adds up the total amount tendered in the edit controls}

              TotaliseEdits;

              {fixes rounding errors (I hope)}
              rTendered := Round(rTendered * 100) / 100;
              rMoneyToBeTaken := Round(rMoneyToBeTaken * 100) / 100;
              rVATIncTotal := Round(rVATIncTotal * 100) / 100;

              // only allow tendering of no more than the full amount of the refund
              if bRefund then begin
                if rTendered < rMoneyToBeTaken then begin
                  MyMsgBox('You cannot refund more than the amount of this transaction.'
                  ,mtError,[mbOK],mbOK,'Refund payment');
                  Exit;
                end;{if}
              end;{if}

              {see if the new TX is going to take them overdrawn}
              OldCustType := CustType;
              if (CustType <> ctOnHold) and (not CreditCheck(Cust, arPayments[pbAccount]))
              and TKSysRec.StopBadDr then CustType := ctOnHold;

              // Am I allowed to leave an amount on account ?
              if (CustType = ctCashOnly) and (arPayments[pbAccount] = rMoneyToBeTaken) then
                begin
                  // Cash Customer leaving full amount on account
                  MyMsgBox('This customer cannot leave the entire amount of this transaction on account.'
                  ,mtError,[mbOK],mbOK,'Account payment prohibited');
                  CustType := OldCustType;
                end
              else begin
                if (CustType = ctCashOnly) and (arPayments[pbAccount] > 0)
                and SetupRecord.NoDepositsOnCashCust then
                  begin
                    // Cash Customer leaving any money on account (and not allowed to)
                    MyMsgBox('This customer cannot leave any amount of this transaction on account.'
                    ,mtError,[mbOK],mbOK,'Account payment prohibited');
                    CustType := OldCustType;
                  end
                else begin
                  if (CustType = ctOnHold) and (rTendered <> rOutstanding) then
                    begin
                      MyMsgBox('This customer cannot leave any amount of this transaction on account.'
                      ,mtError,[mbOK],mbOK,'Account payment prohibited');
                      CustType := OldCustType;
                    end
                  else begin

                    {Enough money ?}
                    if (rTendered < rMoneyToBeTaken) then
                      begin
                        {not enough}
                        if ZeroFloat(rDepositToTake) then
                          begin
                            if aAllowedTo[atWriteOff] and ((CustType = ctNormal)
                            or ((CustType = ctCashOnly) and SetupRecord.AllowWriteOffs4CashCustomers))
                            then Buttons := [mbWriteOff, mbLeaveOutstanding, mbCancel]
                            else Buttons := [mbLeaveOutstanding, mbCancel];

                            iResult := MyMsgBox('You have entered an insufficient amount to cover the remaining value of this transaction.'
                            + #13 + #13 + 'What do you wish to do with this outstanding amount ?',mtConfirmation
                            ,Buttons, mbLeaveOutstanding, 'Amount Outstanding')
                          end
                        else begin
                          MyMsgBox('You have entered an insufficient amount to cover the defined deposit.'
                          ,mtError,[mbOK], mbOK, 'Amount Outstanding');
                          Exit;
                        end;{if}
                      end
                    else begin
                      {enough}
                      iResult := mrLeaveOutstanding;
                    end;{if}

                    if {at least enough money}
                    (((rTendered >= rMoneyToBeTaken)
                    or {not enough money, but we will be writing it off, or leaving it outstanding}
                    ((rTendered < rMoneyToBeTaken) and (iResult <> mrCancel))) and (not bRefund))
                    or {at least enough money (negative)}
                    ((rTendered <= 0) and (bRefund)) then begin

                      {work out change}
                      rChange := rTendered - rMoneyToBeTaken;
                      if ((not bRefund) and (rChange < 0)) or (bRefund and (rChange > 0)) then rChange := 0;
                      if SetupRecord.RoundChange and (SetupRecord.RoundChangeTo > 0) then RoundChange;

                      bOKIt := TRUE;
                      aPayedBy[pbCash] := not ZeroFloat(edCash.Value);
                      aPayedBy[pbCard] := not ZeroFloat(edCard.Value);
                      aPayedBy[pbCheque] := not ZeroFloat(edCheque.Value);

                      sLeftOnAccount := trim(lLeftOnAccount.Caption);
                      sLeftOnAccount := Copy(sLeftOnAccount, Pos(' ',sLeftOnAccount) + 1, Length(sLeftOnAccount));
                      aPayedBy[pbAccount] := not ZeroFloat(StrToFloatDef(sLeftOnAccount, 0));

                      {.167}
                      if (not SetupRecord.CashbackOnOtherMOPs)
                      and ( (not bRefund) and ( (arPayments[pbcheque] > rMoneyToBeTaken)
                      or (arPayments[pbCard] > rMoneyToBeTaken) ))
                      or (bRefund and ( (arPayments[pbcheque] < rMoneyToBeTaken)
                      or (arPayments[pbCard] < rMoneyToBeTaken) )) then
                        begin
                          // Overpaid on Cheque or Card
                          MyMsgBox('You cannot over-pay on Cheque or Credit Card method of payments.'
                          ,mtError,[mbOK],mbOK,'Over-payment prohibited');
                        end
                      else begin

                        CreatePaymentLines;

                        if aPayedBy[pbCard] then begin

                          {Ask for Credit Card details}
                          FrmCardDetails := TFrmCardDetails.Create(Self);
                          with FrmCardDetails do begin
                            try
                              bOKIt := ShowModal = mrOK;
                              if bOKIt then begin

//                                iCardType := TCardInfo(cmbCardType.Items.Objects[cmbCardType.ItemIndex]).CardNo;
                                if cmbCardType.ItemIndex >= 0
                                then iCardType := TCardInfo(cmbCardType.Items.Objects[cmbCardType.ItemIndex]).CardNo
                                else iCardType := -1;

                                asCardDetails[1] := edCardNo.Text;
                                asCardDetails[2] := edCardName.Text;
                                asCardDetails[3] := edExpiry.Text;
                                asCardDetails[4] := edAuthorCode.Text;
                              end;{if}
                            finally
                              Release;
                            end;{try}
                          end;{with}
                        end;{if}

                        {Change Display}
                        if bOKIt then begin
                          {display change}
                          if rTendered > rMoneyToBeTaken then begin
                            lChange.Caption := 'Change : ' + sCurrencySym + ' ' + MoneyToStr(rChange);
                            lChange.Refresh;
                          end;{if}

                          HOOK_OnShowChange;

                          {OK it}
                          btnTender.Caption := 'OK';
                          btnTender.Cancel := TRUE;

                          {enable Reprint}
                          btnReprint.Visible := TRUE;

                          {disable all controls with Tag of 1}
                          for iCont := 0 to ControlCount - 1 do begin
                            if Controls[iCont] is TPanel then
                              begin
                                for iPanCont := 0 to TPanel(Controls[iCont]).ControlCount - 1 do begin
                                  if TWinControl(TPanel(Controls[iCont]).Controls[iPanCont]).Tag > 0
                                  then TWinControl(TPanel(Controls[iCont]).Controls[iPanCont]).Enabled := FALSE;
                                end;{for}
                              end
                            else begin
                              if TWinControl(Controls[iCont]).Tag > 0 then TWinControl(Controls[iCont]).Enabled := FALSE;
                            end;{if}
                          end;{for}

                          {Open Cash Drawer ?}
                          with SetupRecord do begin
{                            if CashDrawerOpenOn[pbCash] and aPayedBy[pbCash]
                            or CashDrawerOpenOn[pbCard] and aPayedBy[pbCard]
                            or CashDrawerOpenOn[pbCheque] and aPayedBy[pbCheque]
                            or CashDrawerOpenOn[pbAccount] and aPayedBy[pbAccount]}
                            if (CashDrawerOpenOn[pbCash] and aPayedBy[pbCash]) // NF: 16/03/2007 Oops! (.282}
                            or (CashDrawerOpenOn[pbCard] and aPayedBy[pbCard])
                            or (CashDrawerOpenOn[pbCheque] and aPayedBy[pbCheque])
                            or (CashDrawerOpenOn[pbAccount] and aPayedBy[pbAccount])
                            then begin
                              if not HOOK_OnFireCashDrawer
                              then OpenCashDrawer(SetupRecord.CashDrawerCOM, SetupRecord.CashDrawerBaudRate, SetupRecord.CashDrawerKick);
                            end;{if}
                          end;{with}

                          // NF: 22/05/2008 {.290} New Custom Event for Tomlinson Parbands
//                          if StoreTransaction(sTXRefNo, iResult, iFolioNum) = 0 then PrintTX(TKTXHeader.OurRef, iFolioNum);
                          if StoreTransaction(sTXRefNo, iResult, iFolioNum) = 0 then
                          begin
                            iCopies := 1;
                            HOOK_TenderBeforePrint(iCopies);
                            if iCopies > 0 then PrintTX(TKTXHeader.OurRef, iFolioNum, iCopies);
                          end;{if}
                          TKTXHeader.OurRef := sTXRefNo;
                        end;{if}
                      end;{if} {.167}
                    end;{if}
                  end;{if}
                end;{if}
              end;{if}
            end;{if}
          end;{with}
        end;{if}
      end
    else begin
      {OK}
      ModalResult := mrOK;
    end;{if}
  end;{if}
end;

procedure TFrmTender.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender, Key, ActiveControl, Handle);
end;

procedure TFrmTender.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  LocalKey : Word;
begin
  GlobFormKeyDown(Sender, Key, Shift, ActiveControl, Handle);
  LocalKey := Key;
  Key := 0;

  {trap function Keys}
  If (LocalKey In [VK_F1..VK_F12]) and (Not (ssAlt In Shift)) then
    begin
      case LocalKey of
//        VK_F1 : Application.HelpCommand(HELP_Finder,0);
        VK_F2 : btnCashClick(nil);
        VK_F3 : btnCardClick(nil);
        VK_F4 : btnChequeClick(nil);
        VK_F5 : btnReprintClick(nil);
        VK_F7 : btnTransDiscountClick(nil);
        VK_F8 : btnSettDiscountClick(nil);
        VK_F9 : btnTenderClick(nil);
        VK_F12 : btnPrinterClick(nil);
        else Key := LocalKey;
      end;{case}
    end
  else Key := LocalKey;
end;

procedure TFrmTender.btnCashClick(Sender: TObject);
var
  rEditTotal : real;
begin
  if btnCash.Enabled then begin
    edCash.Value := StrToFloatDef(edCash.Text, 0);
    ActiveControl := edCash;
    rEditTotal := TotaliseEdits;
    if rEditTotal <> TxRec.rMoneyToBeTaken
    then edCash.Value := edCash.Value + (TxRec.rMoneyToBeTaken - rEditTotal);
    edCash.SelectAll;
    edExit(nil);
  end;{if}
end;

procedure TFrmTender.btnCardClick(Sender: TObject);
var
  rEditTotal : real;
begin
  if btnCard.Enabled then begin
    edCard.Value := StrToFloatDef(edCard.Text, 0);
    ActiveControl := edCard;
    rEditTotal := TotaliseEdits;
    if rEditTotal <> TxRec.rMoneyToBeTaken
    then edCard.Value := edCard.Value + (TxRec.rMoneyToBeTaken - rEditTotal);
    edCard.SelectAll;
    edExit(nil);
  end;{if}
end;

procedure TFrmTender.btnChequeClick(Sender: TObject);
var
  rEditTotal : real;
begin
  if btnCheque.Enabled then begin
    edCheque.Value := StrToFloatDef(edCheque.Text, 0);
    ActiveControl := edCheque;
    rEditTotal := TotaliseEdits;
    if rEditTotal <> TxRec.rMoneyToBeTaken
    then edCheque.Value := edCheque.Value + (TxRec.rMoneyToBeTaken - rEditTotal);
    edCheque.SelectAll;
    edExit(nil);
  end;{if}
end;

procedure TFrmTender.btnAccountClick(Sender: TObject);
begin
  TotaliseEdits;
end;

procedure TFrmTender.FormShow(Sender: TObject);

  function HOOK_TenderOnShow : boolean;
  var
    CurrentLineRec : TTXLineRec;
  begin{HOOK_TenderOnShow}
    Result := FALSE;
    {$IFDEF TCCU}  // Trade Counter Customisation
      // Check to see if the event has been enabled by a Plug-In
      if TradeCustomisation.GotEvent(twiTender, hpTenderOnShow) then begin

        FillChar(CurrentLineRec, SizeOf(CurrentLineRec), #0);

        // Update EventData with current data values
        TradeCustomisation.EventDataO.Assign(Self.Handle, twiTender, hpTenderOnShow
        , TXRec, FrmTXHeader.lvLines, TKLocationRecord, CurrentLineRec, TKPayLines, FrmTXHeader);

        // Execute the Hook Point Event
        TradeCustomisation.ExecuteEvent;

        Result := TRUE;

      end; { If TradeCustomisation.GotEvent... }
    {$ENDIF}
  end;{HOOK_TenderOnShow}

begin
  case DepositMode of
    fmTakeDeposit : lDep2.Caption := 'Deposit to be taken';
    fmOnAccount : begin
      if TXRec.bCardRefund then lDep2.Caption := 'Account Refund'
      else lDep2.Caption := 'To take on account';
      panLeftOnAcc.Visible := FALSE;
    end;
  end;{case}

  lVATAmountTit.Caption := sVATText + ' Amount';
  lAmountTit.Caption := 'Amount (inc. ' + sVATText + ')';

  if TXRec.TKTXHeader.DiscTaken then lSettDiscount.Caption := 'Taken'
  else lSettDiscount.Caption := 'Not Taken';

  EnableDisable;
  bEditChanging := FALSE;
  edExit(nil);

  if edCash.Enabled then ActiveControl := edCash
  else ActiveControl := btnCancel;

  // auto populate Cash Field for Cash only customers
  if TXrec.CustType <> ctNormal then btnCashClick(btnCash);

  // auto populate Card Field for Card refunds
  if TXrec.bCardRefund then btnCardClick(btnCard);

  HOOK_TenderOnShow;
end;

procedure TFrmTender.btnCancelClick(Sender: TObject);
begin
  // Close
  ModalResult := mrCancel;
end;

function TFrmTender.TotaliseEdits : real;
{Adds up the total amount tendered in the first 3 edit controls}
var
  iLine, iCont, iPanCont : integer;
  rValue : real;
begin
  with TXRec do begin
    rTendered := 0;
    for iLine := Ord(Low(TPayedBy)) to Ord(pbCheque) do arPayments[TPayedBy(iLine)] := 0;
    for iCont := 0 to ControlCount - 1 do begin
      if Controls[iCont] is TPanel then begin
        for iPanCont := 0 to TPanel(Controls[iCont]).ControlCount - 1 do begin
          if (TPanel(Controls[iCont]).Controls[iPanCont] is TCurrencyEdit) then begin
            with TCurrencyEdit(TPanel(Controls[iCont]).Controls[iPanCont]) do begin
              rValue := StrToFloatDef(Text, 0);
              if (not ZeroFloat(rValue)) and (Tag <> 4) then begin
                rTendered := rTendered + rValue;
                arPayments[TPayedBy(Tag - 1)] := rValue;
              end;{if}
            end;{with}
          end;{if}
        end;{for}
      end;{if}
    end;{for}
    Result := rTendered;
  end;{with}
end;{if}

function TFrmTender.StoreTransaction(var sTXRefNo : string9; iResult : integer; var iFolioNum : integer) : Integer;
var
  TKTLines : TBatchLinesRec;
  TKMatchRec : TBatchMatchRec;
  LTKTLRec : TBatchTLRec;
  iVatIdx : smallint;
  iMainStockFolio, iPos, iLine : integer;
  rNonDiscTotal, rDiscTotal : double;
  TXType : TTXType;
  rTemp, rTemp2 : real;
  sOrigYourRef, sCustCode, sFullyPayedOffTXType, sMainTXType : string;
  pOurRef : PChar;
  sCC, sDept : string3;
  BlankTXLine : TTXLineRec;
  LTKTXHeader : TBatchTHRec;

{  Function SetTransNat(DocHed : string) : Byte;
  const
    VATINVTTyp     =  10; {*         "      "       Invoices    *}
{    VATCRDTTyp     =  16; {* Intra Stat defaults  - Credit note *}
{    VATIEINVTTyp   =  1; {*         "      "       Invoices    *}
{    IECCode        =  '353';  { Ireland Country code }
{  Begin
    If (TKSysRec.CurrentCountry <> IECCode) then
      Begin
        If (DocHed = 'SRF') or (DocHed = 'PRF') or (DocHed = 'SCR') or (DocHed = 'PCR')
        or (DocHed = 'SJC') or (DocHed = 'PJC') then Result:=VATCRDTTyp
        else Result:=VATInvTTyp;
      end
    else Result:=VATIEInvTTyp;
  end;{SetTransNat}

  function StoreSerialNumbers : smallint;
  var
    LTKTXHeader : TBatchTHRec;
    iStatus, iDescLinesSoFar, iFindLine, iLine, iPos, iSerialPos : integer;
    pOurRef : PChar;
  begin
    Result := 0;
    with FrmTXHeader.LvLines do begin

      {Get Transaction details (so that we can use the ABSLines}
      FillChar(LTKTXHeader, SizeOf(LTKTXHeader), #0);
      FillChar(TKTLines, SizeOf(TKTLines), #0);
      pOurRef := StrAlloc(255);
//      StrPCopy(pOurRef, TXRec.TKTXHeader.OurRef);
      StrPCopy(pOurRef, sTXRefNo);
      iStatus := Ex_GetTrans(@LTKTXHeader, @TKTLines, SizeOf(LTKTXHeader), SizeOf(TKTLines), pOurRef, 0, B_GetEq, FALSE);
      ShowTKError('Ex_GetTrans', 20, iStatus);

      iDescLinesSoFar := 0;
      {each line in the list}
      For iLine := 0 to Items.Count - 1 do begin
        with TTXLineInfo(Items.Item[iLine].Data).TXLineRec, SerialNumbers do begin
          if bDescLine then inc(iDescLinesSoFar);
          if bSerial and Assigned(SerialNumbers) then begin
            {each serial number for this item}
            For iSerialPos := 0 to Count - 1 do begin
              with TSerialInfo(SerialNumbers.Objects[iSerialPos]), TKSerialRec do begin

                CurSell := SetupRecord.TillCurrency;
                CoRate := 1; {check with EL}
                DailyRate := 1; {check with EL}
                if DateUseX = '00000000' then DateUseX := '';

                {set Quantity depending on if it is a batch or not}
                if bBatch then QtyUsed := UsedInThisLine
                else QtyUsed := 1;

                if Sold then
                  begin
                    {unuse serial number record}

                    // rem this out to fix half of the unuse problem
                    OutOrdDoc := OutDoc;
                    OutDoc := sTXRefNo;

                    // add this in to fix the +/- problem
//                    QtyUsed := -QtyUsed;

                    {find line in toolkit structure}
                    iFindLine := 0;
                    For iPos := 1 to LTKTXHeader.LineCount do begin
                      if (not TKTLines[iPos].Payment) and (TKTLines[iPos].KitLink <= 0) then inc(iFindLine);
                      if iFindLine = (iLine + 1 - iDescLinesSoFar) then begin
                        SoldABSLine := TKTLines[iPos].ABSLineNo;
                        Break;
                      end;{if}
                    end;{for}

                    Result := Ex_UnUseSerialBatch(@TKSerialRec, SizeOf(TKSerialRec), B_Update);
                    ShowTKError('EX_UnUseSerialBatch', 163, Result);
                  end
                else begin
                  DateOut := DateTimeAsLongDate(date);

//                  OutDoc := TxRec.TKTXHeader.OurRef;
                  OutDoc := sTXRefNo;{.200}
                  
                  OutMLoc := SetupRecord.DefStockLocation;

                  {find line in toolkit structure}
                  iFindLine := 0;
                  For iPos := 1 to LTKTXHeader.LineCount do begin
                    if (not TKTLines[iPos].Payment) and (TKTLines[iPos].KitLink <= 0) then inc(iFindLine);
                    if iFindLine = (iLine + 1 - iDescLinesSoFar) then begin
                      SoldABSLine := TKTLines[iPos].ABSLineNo;
                      Break;
                    end;{if}
                  end;{for}

                  {store serial number record}
                  Result := EX_UseSerialBatch(@TKSerialRec, SizeOf(TKSerialRec), B_Insert);
                  ShowTKError('EX_UseSerialBatch', 97, Result);
                end;{if}

              end;{with}
            end;{for}
          end;{if}
        end;{with}
      end;{for}
    end;{with}
  end;{StoreSerialNumbers}

  function StoreBinNumbers : smallint;
  var
    LTKTXHeader : TBatchTHRec;
    iStatus, iDescLinesSoFar, iFindLine, iLine, iPos, iBinPos : integer;
    pOurRef : PChar;
  begin
    Result := 0;
    with FrmTXHeader.LvLines do begin

      {Get Transaction details (so that we can use the ABSLines}
      FillChar(LTKTXHeader, SizeOf(LTKTXHeader), #0);
      FillChar(TKTLines, SizeOf(TKTLines), #0);
      pOurRef := StrAlloc(255);
//      StrPCopy(pOurRef, TXRec.TKTXHeader.OurRef);
      StrPCopy(pOurRef, sTXRefNo);
      iStatus := Ex_GetTrans(@LTKTXHeader, @TKTLines, SizeOf(LTKTXHeader), SizeOf(TKTLines), pOurRef, 0, B_GetEq, FALSE);
      ShowTKError('Ex_GetTrans', 20, iStatus);

      iDescLinesSoFar := 0;
      {each line in the list}
      For iLine := 0 to Items.Count - 1 do begin
        with TTXLineInfo(Items.Item[iLine].Data).TXLineRec, BinNumbers do begin
          if bDescLine then inc(iDescLinesSoFar);
          if TKStockRec.UsesBins and Assigned(BinNumbers) then begin
            {each Bin number for this item}
            For iBinPos := 0 to Count - 1 do begin
              with TBinInfo(BinNumbers.Objects[iBinPos]), TKBinRec do begin

                brCostPriceCurrency := SetupRecord.TillCurrency;
                brSalesPriceCurrency := SetupRecord.TillCurrency;
                brCompanyRate := 1; {check with EL}
                brDailyRate := 1; {check with EL}
                if brUseByDate = '00000000' then brUseByDate := '';

                brQtyUsed := ABS(UsedInThisLine);
//                brQtyUsed := UsedInThisLine;

                if brSold then
                  begin
                    {unuse Bin number record}

                    // rem this out to fix half of the unuse problem
//                    brOutOrderRef := brOutDocRef;
//                    brOutDocRef := sTXRefNo;
                    brOutOrderRef := '';

                    // add this in to fix the +/- problem
//                    QtyUsed := -QtyUsed;

                    {find line in toolkit structure}
                    iFindLine := 0;
                    For iPos := 1 to LTKTXHeader.LineCount do begin
                      if (not TKTLines[iPos].Payment) and (TKTLines[iPos].KitLink <= 0) then inc(iFindLine);
                      if iFindLine = (iLine + 1 - iDescLinesSoFar) then begin
                        brOutDocLine := TKTLines[iPos].ABSLineNo;
                        Break;
                      end;{if}
                    end;{for}

                    Result := Ex_UnUseMultiBin(@TKBinRec, SizeOf(TKBinRec));
                    ShowTKError('Ex_UnUseMultiBin', 175, Result);
                  end
                else begin
                  brOutDate := DateTimeAsLongDate(date);

//                  OutDoc := TxRec.TKTXHeader.OurRef;
                  brOutDocRef := sTXRefNo;{.200}

                  brOutLocation := SetupRecord.DefStockLocation;

                  {find line in toolkit structure}
                  iFindLine := 0;
                  For iPos := 1 to LTKTXHeader.LineCount do begin
                    if (not TKTLines[iPos].Payment) and (TKTLines[iPos].KitLink <= 0) then inc(iFindLine);
                    if iFindLine = (iLine + 1 - iDescLinesSoFar) then begin
                      brOutDocLine := TKTLines[iPos].ABSLineNo;
                      Break;
                    end;{if}
                  end;{for}

                  {store Bin number record}
                  Result := EX_UseMultiBin(@TKBinRec, SizeOf(TKBinRec));
                  ShowTKError('EX_UseMultiBin', 174, Result);
                end;{if}

              end;{with}
            end;{for}
          end;{if}
        end;{with}
      end;{for}
    end;{with}
  end;{StoreBinNumbers}

  (*
  procedure FillTKTLines;
  var
    iLine : integer;
  begin{FillTKTLines}
    with FrmTXHeader.LvLines do begin
      For iLine := 1 to Items.Count do begin
        with TTXLineInfo(Items.Item[iLine].Data), TXLineRec do begin
          TKTLines[iLine] := TKTLRec;
        end;{with}
      end;{for}
    end;{with}
  end;{FillTKTLines}
  *)

var
  sOriginalTXRefNo : string;{.281}

begin{StoreTransaction}

  {Initialise record structures}
  FillChar(TKTLines, SizeOf(TKTLines), #0);
  InitialiseTXLine(BlankTXLine);

  with TxRec, TKTXHeader do begin

//    sTXRefNo := OurRef;
    sOriginalTXRefNo := OurRef;{.281}

    if (TXRec.rNetTotal < 0) and (SetupRecord.NegativeTXType = 1) then
      begin
        // Negative TX AND Create SRFs / SCRs
        sMainTXType := 'SCR';
        sFullyPayedOffTXType := 'SRF';
      end
    else begin
      case SetupRecord.TransactionType of

        TX_SINs : begin
            sMainTXType := 'SIN';
            sFullyPayedOffTXType := 'SRI';

{          case DepositMode of
            fmTakeDeposit : begin
              sMainTXType := 'SIN';
              sFullyPayedOffTXType := 'SRI';
            end;

            fmOnAccount : begin
              sMainTXType := 'SCR';
              sFullyPayedOffTXType := 'SRF';
            end;
          end;{case}
        end;

        TX_PICKED_SORs, TX_UNPICKED_SORs : begin
          sMainTXType := 'SOR';

          case SetupRecord.TagNoFrom of
            0 : TKTXHeader.Tagged := SetupRecord.TransactionTagNo;
            1 : TKTXHeader.Tagged := TXRec.LCust.DefTagNo;
            2 : begin
              if TXRec.LCust.DefTagNo = 0
              then TKTXHeader.Tagged := SetupRecord.TransactionTagNo
              else TKTXHeader.Tagged := TXRec.LCust.DefTagNo;
            end;
          end;{case}
//          TKTXHeader.Tagged := SetupRecord.TransactionTagNo;
          sFullyPayedOffTXType := 'SOR';
        end;

      end;{case}
    end;{if}


    // Add Transaction

    // determine transaction type
    if ZeroFloat(rTendered) and (iResult <> mrWriteOff) then
      begin
        {No Money Tendered - SIN}
        TXType := ttOrder;
        TransDocHed := sMainTXType;
      end
    else begin
      {full amount payed (or more) }

      if TKTXHeader.DiscTaken then rTemp := rVATIncTotal - TKTXHeader.DiscSetAm
      else rTemp := rVATIncTotal;
      rTemp := Round(rTemp * 100) / 100;

      rTemp2 := (rTendered - rChange + ABS(rWrittenOff));
      rTemp2 := Round(rTemp2 * 100) / 100;

//      if ABS((rTendered - rChange + ABS(rWrittenOff))) >= ABS(rTemp) then
      if ABS(rTemp2) >= ABS(rTemp) then
        begin
          if (not aPayedBy[pbCash]) and (not aPayedBy[pbCard]) and (not aPayedBy[pbCheque])
          and aPayedBy[pbAccount] then
            begin
              {Everything put on account - SIN}
              TXType := ttOrder;
              TransDocHed := sMainTXType;
            end
          else begin
            {Full amount tendered}
            case TenderMode of
              tmAdd : begin
                {Fully Paid Off - SRI / SRF (SRC for SOR type)}
                if (TXRec.rNetTotal < 0) and (SetupRecord.NegativeTXType = 1) then TXType := ttPayedOff
                else begin
                  case SetupRecord.TransactionType of
                    TX_SINs : TXType := ttPayedOff;
                    TX_PICKED_SORs, TX_UNPICKED_SORs : TXType := ttPartPayment;
                  end;{case}
                end;{if}
                TransDocHed := sFullyPayedOffTXType;
              end;

              tmEdit : begin
                {Leave remaining amount outstanding : Partial Payment - SIN + SRC}
                TXType := ttPartPayment;
                TransDocHed := sMainTXType;
              end;
            end;{if}
          end;{if}
        end
      else begin
        case iResult of
          mrLeaveOutstanding : begin
            {Leave remaining amount outstanding : Partial Payment - SIN + SRC}
            TXType := ttPartPayment;
            TransDocHed := sMainTXType;
          end;

          mrWriteOff : begin
            lOSDesc.Caption := 'Amount Written-Off';
            {Write off remaining amount}
            case TenderMode of
              tmAdd : begin
                {No SIN already created - so Create SRI}
                case SetupRecord.TransactionType of
                  TX_SINs : TXType := ttPayedOff;
                  TX_PICKED_SORs, TX_UNPICKED_SORs : TXType := ttPartPayment;
                end;{case}
                TransDocHed := sFullyPayedOffTXType;
              end;

              tmEdit : begin
                {SIN already created - so Create SRC}
                TXType := ttPartPayment;
                TransDocHed := sMainTXType; {I know this doesn't say SRC....Just Don't ask}
              end;
            end;{if}
          end;
        end;{case}
      end;{if}
    end;{if}

    TKTXHeader.InvVat := 0;
    FillChar(TKTXHeader.InvVatAnal, SizeOf(TKTXHeader.InvVatAnal),#0);
    TKTXHeader.InvNetVal := 0;
    Settled := 0;
    DiscAmount := 0;{.213}

    {Transaction Lines}

    {All TX types}
    with FrmTXHeader.LvLines do begin
      For iLine := 0 to Items.Count - 1 do begin
//        TKTLine := TKTLines[iLine + 1];
        with TTXLineInfo(Items.Item[iLine].Data), TXLineRec do
        begin
          {All lines}

          // Blank out GL / CC / Dept for MBD Lines
          if bMBDLine then
          begin
            TKTLRec.NomCode := 0;
            TKTLRec.CC := '';
            TKTLRec.Dep := '';
          end;

          {.229}
          TKTLRec.LineNo := (iLine + 1) * 2;// Reset ALL the line numbers

          TKTLRec.Desc := Items.Item[iLine].SubItems[0];

          if bDescLine then
          begin
            {Additional description lines}
//              TKTLRec.KitLink := 1;
            if not TXLineRec.bNonStock {.281} // This should already be set to -1999999999 for non stock additional description lines.
            then TKTLRec.KitLink := iMainStockFolio; {.229}

            {.299}
            // make sure no TTD/VBD is applied to additional desc lines
            rDiscount3 := 0;
            cDiscount3 := #0;
            iDiscount3Type := 0;
            TKTLRec.tlTransValueDiscount := 0;
            TKTLRec.tlTransValueDiscountChr := #0;
            TKTLRec.tlTransValueDiscountType := 0;
          end else
          begin
            {Normal lines}

            {.229}
            iMainStockFolio := TKStockRec.StockFolio;

//            TKTLRec.KitLink := iKitLink;

//            if not bDateChangedByCustomisation
//            then TKTLRec.LineDate := TransDate;

            {.281}
(*            if not bDateChangedByCustomisation then
            begin
              // If Unpicked SOR, then set the Line Date to the Header Due Date.
              if (SetupRecord.TransactionType = TX_UNPICKED_SORs) then
              begin
                TKTLRec.LineDate := DueDate;
              end else
              begin
                TKTLRec.LineDate := TransDate;
              end;{if}
            end;{if}*)

            {.281}
            // Mark this Line as "Date Changed by Customisation" (We will remove this later)
            if bDateChangedByCustomisation
            then TKTLRec.PadChar1[1] := '*';

//            TKTLRec.StockCode := sStockCode;

//            GetCCDept(sCC, sDept, TXLineRec);
//            TKTLRec.CC := sCC;
//            TKTLRec.Dep := sDept;

            if TKSysRec.MultiLocn > 0 then TKTLRec.MLocStk := SetupRecord.DefStockLocation;
            TKTLRec.DocLTLink := TKStockRec.StkLinkLT;

            TKTLRec.Currency := SetupRecord.TillCurrency;
            TKTLRec.CoRate := CoRate;
            TKTLRec.VatRate := VatRate;

            {.240}
            // Added so that split packs work
            if not tkstockrec.StDPackQty
            then TKTLRec.QtyMul := tkstockrec.SellUnit;

            // Line GL Code
{            if TXRec.LCust.DefNomCode <> 0 then TKTLRec.NomCode := TXRec.LCust.DefNomCode
            else begin
              if Trim(TKTLRec.StockCode) = '' then TKTLRec.NomCode := SetupRecord.DefNonStockNomCode
              else begin
                if (TKSysRec.MultiLocn > 0) and TKLocationRecord.loUseNom
                then
                  begin
                    if TKStockLocRec.lsDefNom[1] = 0 then TKTLRec.NomCode := TKLocationRecord.loNominal[1] // Get GL Code from Location Record
                    else TKTLRec.NomCode := TKStockLocRec.lsDefNom[1]; // Get GL Code from Stock Location Record
                  end
                else TKTLRec.NomCode := TKStockRec.NomCodeS[1]; // Get GL Code from Stock Record
              end;{if}
{            end;{if}

//            TKTLRec.Qty := rQuantity;


//            TKTLRec.QtyMul := TKStockRec.SellUnit;
//            TKTLRec.QtyMul := 1; {.195}

//            TKTLRec.NetValue := rPreEPOSDiscount;
            {.197}
            Case SetupRecord.DiscountType of
              0 : begin // TCM Additional Discounts
                {.215}
//                if (cDiscount = #0) then TKTLRec.NetValue := rPreEPOSDiscount;
                if bVATInclusive then
                begin
                  if bNonStock then
                  begin
{                    if (cDiscount = DT_PERCENTAGE) then
                    begin
                      TKTLRec.NetValue := rPreEPOSDiscount;
                    end else}
                    begin
                      // Leave NetValue alone
                    end;
                  end else
                  begin
                    // NF: 31/05/2011 v6.70.317
                    // fix for https://jira.iris.co.uk/browse/ABSEXCH-11404
                    // This seems to cause a problem with TXs with Settlement discount.....
                    if Zerofloat(TXRec.TKTXHeader.Discsetl)
                    then TKTLRec.NetValue := TKTLRec.IncNetValue - rVATAmountforOne;
//                    TKTLRec.NetValue := TKTLRec.IncNetValue - rVATAmountforOne;
                  end;{if}
                end else
                begin
                  // not VAT Inclusive
                  TKTLRec.NetValue := rPreEPOSDiscount;
                end;{if}
              end;

              1 : begin // Using and Modifying Enterprise Discounts
                if cDiscount = DT_OVERRIDE_PRICE then
                begin
                  {.234}
                  // fix for split packs problem as reported my mcKenna
                  if (TKStockRec.StPricePack) {and TKSysRec.InputPackQtyOnLine}
                  then TKTLRec.NetValue := TKTLRec.NetValue * TKStockRec.SellUnit;
                end else
                begin
                  {.213}
                  if bVATInclusive or bBOMComponent {.198} or bNonStock {.199} then TKTLRec.NetValue := rPreEPOSDiscount
                  else begin
                    // fixes problem with doing "Create from" on TXs with override price on use and mod enterprise disounts
                    if zerofloat(TKTLRec.NetValue) then TKTLRec.NetValue := TKStockPriceRec.Price;
                    // TKTLRec.NetValue := TKStockPriceRec.Price;
                  end;{if}
                end;{if}

//                if bVATInclusive or bBOMComponent {.198} or bNonStock {.199} then TKTLRec.NetValue := rPreEPOSDiscount
//                else TKTLRec.NetValue := TKStockPriceRec.Price;
              end;
            end;{case}

            if (TKSysRec.MultiLocn > 0) and TKLocationRecord.loUseCPrice
            then TKTLRec.CostPrice := TKStockLocRec.lsCostPrice // Get GL Code from Stock Location Record
            else TKTLRec.CostPrice := TKStockRec.CostPrice; // Get GL Code from Stock Record

//            TKTLRec.VATCode := cVATCode;
{            if (TKTLRec.VATCode in ['I', 'M']) then begin
              TKTLRec.VATCode := 'M';
              TKTLRec.VATIncFlg := TKStockRec.SVATIncFlg;
            end;{if}

            // Make Inclusive VAT Non-Stock Items come out as Vat=MS
{            if (bVATInclusive and bNonStock) then begin
              TKTLRec.VATCode := 'M';
              TKTLRec.VATIncFlg := TKTLRec.VATCode;
            end;{if}

//            TKTLRec.VAT := rTotalVATAmount;

            {Discount}
//            TKTLRec.DiscountChr := ' ';
//            TKTLRec.Discount := rDiscAmount;

{            Case cDiscount of
              '%' : begin
                TKTLRec.DiscountChr := '%';
                TKTLRec.Discount := rDiscount / 100;
              end;

              #0 : begin
                TKTLRec.DiscountChr := ' ';
                TKTLRec.Discount := rDiscAmount;
              end;

              '£' : begin
                TKTLRec.NetValue := rNetPrice;
              end;
            end;{case}

            {Intrastat stuff}
{            if TKSysRec.IntraStat and LCust.EECMember then begin
              TKTLRec.SSDUplift := TKStockRec.SSDDUplift;
              TKTLRec.SSDCommod := TKStockRec.CommodCode;
              TKTLRec.SSDSPUnit := TKStockRec.SuppSUnit;
              TKTLRec.SSDCountry := TKStockRec.SSDCountry;
              TKTLRec.SSDUseLine := FALSE;
            end;{if}

//            if SetupRecord.TransactionType = 1 then TKTLRec.QtyPick := TKTLRec.Qty;

            {Update TX Header}

            // Value - excluding Line and Settlement Discount

{            if bVATInclusive and (SetupRecord.DiscountType = 0) and (cDiscount = #0) then begin
              TKTLRec.NetValue := rNetPrice + rDiscAmount;
//              TKTLRec.IncNetValue := Round_Up(TKTLRec.NetValue + rVATAmountforOne, TKSysRec.PriceDP);
            end;{if}

            if bVATInclusive and (SetupRecord.DiscountType = 0) then
            begin
              case cDiscount of
                DT_DISCOUNT_AMOUNT  : TKTLRec.NetValue := rNetPrice + rDiscAmount;
              end;{case}
            end;{if}

            LTKTLRec := TKTLRec;
            LTKTLRec.TransRefNo := 'SIN'; // Ex_GetLineTotal needs to know the TX Type in order to get the correct amount of decimal places NF: 08/11/2005
            Result := Ex_GetLineTotal(@LTKTLRec, SizeOf(LTKTLRec), FALSE, 0.0, rNonDiscTotal);
            //Result := Ex_GetLineTotal(@LTKTLRec, SizeOf(LTKTLRec), TRUE, 0.0, rNonDiscTotal); {.194}
            ShowTKError('Ex_GetLineTotal', 127, Result);
            if Result = 0 then
            begin
              if bVATInclusive then InvNetVal := InvNetVal + rTotalNetNoDiscounts + rIncVATDiscDiff
              else InvNetVal := InvNetVal + rNonDiscTotal;
            end;{if}

            {.213}
            if not ((SetupRecord.DiscountType = 1) and (cDiscount = DT_OVERRIDE_PRICE)) then
            begin
              if bVATInclusive then DiscAmount := DiscAmount + rTotalStandardDiscountAmount + rTotalMBDAmount + rTotalTransDiscountAmount
              else DiscAmount := DiscAmount + Round_Up(rTotalDiscAmount, TKSysRec.PriceDP);
            end;{if}

            // fix for non-stock, vat inclusive items

            {.251}
{            if bVATInclusive and bNonStock
            then TKTLRec.IncNetValue := rNonDiscTotal + TKTLRec.VAT;}

            {.256}
{            if bVATInclusive and bNonStock
            then TKTLRec.IncNetValue := Round_Up(rPrice, TKSysRec.PriceDP);}

            {.257}
            if bVATInclusive {and (SetupRecord.DiscountType = 0)} and bNonStock
            then TKTLRec.IncNetValue := Round_Up(rPrice + rDiscAmount, TKSysRec.PriceDP);

            {.259}
            if bVATInclusive {and (SetupRecord.DiscountType = 0)} and bNonStock
            then TKTLRec.IncNetValue := Round_Up(rOrigVatIncPrice, TKSysRec.PriceDP);



//            DiscAmount := DiscAmount + Round_Up(rTotalDiscAmount, TKSysRec.PriceDP);


//            Result := Ex_GetLineTotal(@TKTLRec, SizeOf(TKTLRec), False, 0.0, rNonDiscTotal);
//            ShowTKError('Ex_GetLineTotal', 127, Result);
//            if Result = 0 then begin
//              InvNetVal := InvNetVal + rNonDiscTotal;

//              InvNetVal := InvNetVal + rNetValue;


//InvNetVal := InvNetVal + Round_Up(Round_Up(rPreEPOSDiscount, TKSysRec.PriceDP) * TKTLRec.Qty, TKSysRec.PriceDP);

//DiscAmount := 10;

//              DiscAmount := DiscAmount + Round_Up(rDiscAmount * TKTLRec.Qty, TKSysRec.PriceDP);
//              DiscAmount := DiscAmount + Round_Up(Round_Up(TKTLRec.Discount, TKSysRec.PriceDP) * TKTLRec.Qty, TKSysRec.PriceDP);

//              if cDiscount = '£' then InvNetVal := Round_Up(InvNetVal - (rDiscAmount * TKTLRec.Qty), TKSysRec.PriceDP);


//              InvNetVal := InvNetVal + Round_Up(rLineNetTotal, 2);

              // Line Discount
(*             if DoDiscountLineTotal(TTXLineInfo(FrmTXHeader.LvLines.items[iLine].data).TXLineRec
             , TKTLRec, TKTLRec.Qty, rDiscTotal, TRUE, (cDiscount <> '£')) = 0 then begin
                DiscAmount := DiscAmount + (rNonDiscTotal - rDiscTotal);

                // Update VAT Analysis & Totals
                if (TKTLRec.VATCode = 'D') and TXRec.LCust.EECMember then iVatIdx := 6
                else begin
                  if TKTLRec.VATCode in ['M', 'I'] then iVatIdx := VatCharToIdx(TKTLRec.VATIncFlg)
                  else iVatIdx := VatCharToIdx(TKTLRec.VATCode);
                end;{if}
                InvVatAnal[iVatIdx] := InvVatAnal[iVatIdx] + TKTLRec.VAT;
                InvVat := InvVat + TKTLRec.VAT;

              end;{if}
            end;{if}
*)
              // Line Discount
//              DiscAmount := DiscAmount
//              + Round_Up(TTXLineInfo(FrmTXHeader.LvLines.items[iLine].data).TXLineRec.rDiscAmount, 2);
//              DiscAmount := DiscAmount + (rNonDiscTotal - rDiscTotal);

            // Update VAT Analysis & Totals
            iVatIdx := -1;{.221}
            if (TKTLRec.VATCode = 'D') and TXRec.LCust.EECMember then iVatIdx := 6
            else begin
              if TKTLRec.VATCode in ['M', 'I'] then iVatIdx := VatCharToIdx(TKTLRec.VATIncFlg)
              else begin
                if TKTLRec.VATCode <> #0 then iVatIdx := VatCharToIdx(TKTLRec.VATCode);{.221}
              end;{if}
            end;{if}

            if (iVatIdx <> -1) then InvVatAnal[iVatIdx] := InvVatAnal[iVatIdx] + TKTLRec.VAT; {.221}
            InvVat := InvVat + TKTLRec.VAT;

//            end;{if}

            if TXType = ttPayedOff then Settled := Settled + rLineTotal;

          end;{if}

          TKTLines[iLine + 1] := TKTLRec;
          TKTLines[iLine + 1].CostPrice := 0;

        end;{with}

      end;{for}

      {Set TX Header}

      LineCount := Items.Count;
//      LineCount := (Items.Count * 2) + 1;

      ManVAT := FALSE;
{      ManVAT := TRUE;}

      {Intrastat stuff}
//      if TKSysRec.IntraStat and LCust.EECMember then begin
//        TransNat := SetTransNat(Trim(TransDocHed));

//        TransMode := LCust.SSDModeTr;
//        if TransMode = 0 then TransMode := SetupRecord.DefSSDModeOfTrans;

//        SSDProcess := ' ';

//        DelTerms := LCust.SSDDelTerms;
//        if DelTerms = '' then DelTerms := SetupRecord.DefSSDDeliveryTerms;
//      end;{if}

      {settlement discount}
//      DiscSetl := TKTXHeader.DiscSetl;
//      if not ZeroFloat(rSettlementDisc) then DiscDays := TKTXHeader.DiscDays;
//      DiscTaken := bTakeSettlement;
//      DiscSetAm := TKTXHeader.DiscSetAm;
    end;{with}

    {calculates the DueDate of the TX from the payment terms of the customer}
    if (TKTXHeader.TransDocHed = sMainTXType) {and (CustType <> ctCashOnly)} then
    begin
//      TKTXHeader.DueDate := CalcDueDate(TransDate,LCust.PayTerms);

      {.281}
      // Set the Due Date for SINs and Unpicked SORs. If Picked SOR, then Do not set the Due Date.
      if SetupRecord.TransactionType in [TX_SINs, TX_UNPICKED_SORs] then
      begin
        TKTXHeader.DueDate := CalcDueDate(TransDate,LCust.PayTerms);

        // Set Line Dates
        For iPos := 1 to TKTXHeader.LineCount do
        begin
          // Check Flag. This flag, shows if the LineDate has been modified by the customisation.
          if TKTLines[iPos].PadChar1[1] = '*' then
          begin
            // Reset Flag
            TKTLines[iPos].PadChar1[1] := #0;
          end else
          begin
            // If Unpicked SOR, then set the Line Date to the Header Due Date.
            if (SetupRecord.TransactionType = TX_UNPICKED_SORs) then
            begin
              TKTLines[iPos].LineDate := DueDate;
            end else
            begin
              TKTLines[iPos].LineDate := TransDate;
            end;{if}
          end;{if}
        end;{for}
      end;{if}

    end;{if}

    if TXType in [ttPayedOff, ttPartPayment] then begin

      if (TXType = ttPartPayment) or (DepositMode = fmOnAccount) then
      begin

        if TenderMode = tmAdd then begin

          // Creating an SCR, so negate Transaction
          if TransDocHed = 'SCR' then begin
            NegateTKTXHeader(TKTXHeader);
            NegateTKTLines(TKTLines, TKTXHeader);
          end;{if}

          // Stores SIN/SOR/SCR (prior to SRC)
          if (DepositMode = fmTakeDeposit) then // don't store SOR/SIN/SCR for On Account TXs
          begin
//            LineCount := (LineCount * 2) + 1;
            Result := Ex_StoreTrans(@TKTXHeader,@TKTLines,SizeOf(TKTXHeader),SizeOf(TKTLines),0,B_Insert);
            ShowTKError('Ex_StoreTrans', 21, Result);
            if Result <> 0 then Exit;
          end;{if}

          // Return Reference of SIN for printing
          sTXRefNo := OurRef;
          iFolioNum := FolioNum;


          // For Picked SORs
          if (SetupRecord.TransactionType = TX_PICKED_SORs) and (DepositMode = fmTakeDeposit) then
          begin

            // You have to edit the transaction, to set the Picked quantity on the Lines - Pants !

            // Find TX
            FillChar(LTKTXHeader, SizeOf(LTKTXHeader), #0);
            FillChar(TKTLines, SizeOf(TKTLines), #0);
            pOurRef := StrAlloc(255);
            StrPCopy(pOurRef,sTXRefNo);
            Result := Ex_GetTrans(@LTKTXHeader, @TKTLines, SizeOf(LTKTXHeader), SizeOf(TKTLines), pOurRef, 0, B_GetEq, FALSE);
            ShowTKError('Ex_GetTrans', 20, Result);
            StrDispose(pOurRef);

            if Result = 0 then begin

              // Set all lines to be picked
              For iPos := 1 to LTKTXHeader.LineCount do begin
                if (not TKTLines[iPos].Payment) and (TKTLines[iPos].KitLink <= 0) then begin
                  TKTLines[iPos].QtyPick := TKTLines[iPos].Qty;
                end;{if}
              end;{for}

              // Stores Edited SOR
              Result := Ex_StoreTrans(@LTKTXHeader,@TKTLines,SizeOf(LTKTXHeader),SizeOf(TKTLines),0,B_Update);
              ShowTKError('Ex_StoreTrans', 21, Result);
              if Result <> 0 then Exit;
            end;{if}
          end;{if}

          if (Result = 0) and (DepositMode = fmTakeDeposit)
          then AddNotes;
        end;{if}

        // save ourref for storing SRCs
//        if SetupRecord.TransactionType in [1,2] then sTXRefNo := OurRef;

// I think these were just for debuging
//        sTXRefNo := OurRef;
//        sTXRefNo := YourRef;

        // NF: 28/11/05 This was changed (above) so that the Ref No was shown when printing
        // unfortuately this seems to have screwed up Paid Off SORs.
        // I have had to change this back(ish) as Paid Off SORs were not storing correctly
//        if SetupRecord.TransactionType in [1,2] then sTXRefNo := OurRef
//        else sTXRefNo := YourRef;

        // NF: 26/01/06 - I have now changed this back to the original, as it was causing all sort of trouble.
        if SetupRecord.TransactionType in [TX_PICKED_SORs, TX_UNPICKED_SORs] then sTXRefNo := OurRef;

        {Initialise record structures}
        sCustCode := CustCode;
        sOrigYourRef := TxRec.TKTXHeader.YourRef;{.279}
        FillChar(TKTXHeader, SizeOf(TKTXHeader), #0);
        FillChar(TKTLines, SizeOf(TKTLines), #0);

        {for Partial Payment add an SRC as well}
        FillStandardTXHead(TKTXHeader);
        CustCode := sCustCode;
        TransDocHed := 'SRC';

//        if SetupRecord.TransactionType in [1,2] then YourRef := sTXRefNo;

//        YourRef := sTXRefNo;{.279}
        {.279}
        if DepositMode = fmOnAccount then
        begin
          YourRef := sOrigYourRef;
        end else
        begin
          YourRef := sTXRefNo;
        end;{if}

      end;{if}

      {1 Extra Line per MOP (except account)}
      For iLine := 1 to High(TKPayLines) do begin
        if TKPayLines[iLine].Desc <> '' then begin
          LineCount := LineCount + 1;
          TKTLines[LineCount] := TKPayLines[iLine];
          TKTLines[LineCount].LineNo := TKTXHeader.LineCount * 2;

          if TKTLines[LineCount].Desc = 'Card Payment' then begin
            // ammend details for credit card payments
            if iCardType >= 0 then TKTLines[LineCount].Desc := TPayedByToText(pbCard,iCardType);
            if iCardType >= 0 then TKTLines[LineCount].NomCode := SetupRecord.CreditCards[iCardType].GLCode;
            TKTLines[LineCount].LineUser1 := asCardDetails[1];
            TKTLines[LineCount].LineUser2 := asCardDetails[2];
            TKTLines[LineCount].LineUser3 := asCardDetails[3];
            TKTLines[LineCount].LineUser4 := asCardDetails[4];
          end;{if}
        end;{if}
      end;{for}

      {1 Extra Line per MOP (except account)}
(*      For iLine := Ord(Low(TPayedBy)) to (Ord(High(TPayedBy)) - 1)  do begin
        if not ZeroFloat(arPayments[TPayedBy(iLine)]) then begin
          LineCount := LineCount + 1;

          GetCCDept(sCC, sDept, BlankTXLine);
//          TKTLines[LineCount].StockCode := 'Payment';

          TKTLines[LineCount].StockCode := 'TC:' + DateToStr(Date);
          TKTLines[LineCount].Desc := TPayedByToText(TPayedBy(iLine),iCardType);
          TKTLines[LineCount].Currency := SetupRecord.TillCurrency;
          TKTLines[LineCount].CoRate := CoRate;
          TKTLines[LineCount].VatRate := VatRate;
          TKTLines[LineCount].LineNo := LineCount * 2;
          TKTLines[LineCount].LineDate := TransDate;
          TKTLines[LineCount].CC := sCC;
          TKTLines[LineCount].Dep := sDept;

          if TPayedBy(iLine) = pbCard then TKTLines[LineCount].NomCode := SetupRecord.CreditCards[iCardType].GLCode
          else TKTLines[LineCount].NomCode := SetupRecord.MOPNomCodes[TPayedBy(iLine)];

          TKTLines[LineCount].Qty := 1;
          TKTLines[LineCount].QtyMul := 1;
          TKTLines[LineCount].Payment := TRUE;

          if (not ZeroFloat(rChange)) and (TPayedBy(iLine) = pbCash) then TKTLines[LineCount].NetValue := arPayments[TPayedBy(iLine)] - rChange
          else TKTLines[LineCount].NetValue := arPayments[TPayedBy(iLine)];

          if TPayedBy(iLine) = pbCard then begin
            TKTLines[LineCount].LineUser1 := asCardDetails[1];
            TKTLines[LineCount].LineUser2 := asCardDetails[2];
            TKTLines[LineCount].LineUser3 := asCardDetails[3];
            TKTLines[LineCount].LineUser4 := asCardDetails[4];
          end;{if}
        end;{if}
      end;{for}*)
    end;{if}

    {Add Discount line for written-Off Amount}
    if iResult = mrWriteOff then rWrittenOff := Round((rWrittenOff + rMoneyToBeTaken - rTendered) * 100) / 100;
    if rWrittenOff <> 0 then begin
      LineCount := LineCount + 1;

      GetCCDept(sCC, sDept, BlankTXLine);
      TKTLines[LineCount].Currency := SetupRecord.TillCurrency;
      TKTLines[LineCount].CoRate := CoRate;
      TKTLines[LineCount].VatRate := VatRate;
      TKTLines[LineCount].LineNo := LineCount * 2;

//      TKTLines[LineCount].LineDate := TransDate;

      {.281}
      // If Unpicked SOR, then set the Line Date to the Header Due Date.
      if (SetupRecord.TransactionType = TX_UNPICKED_SORs) then
      begin
        TKTLines[LineCount].LineDate := DueDate;
      end else
      begin
        TKTLines[LineCount].LineDate := TransDate;
      end;{if}

      TKTLines[LineCount].CC := sCC;
      TKTLines[LineCount].Dep := sDept;
      TKTLines[LineCount].NomCode := SetupRecord.WriteOffNomCode;
      TKTLines[LineCount].Qty := 1;
      TKTLines[LineCount].QtyMul := 1;
      TKTLines[LineCount].StockCode := 'Write-Off';
      TKTLines[LineCount].Desc := 'Discount (write-off)';
      TKTLines[LineCount].Payment := TRUE;
      TKTLines[LineCount].NetValue := rWrittenOff;

      arPayments[pbAccount] := 0;
    end;{if}

    if (TXType = ttPartPayment) or (DepositMode = fmOnAccount) then begin
      for iLine := 1 to LineCount do InvNetVal := InvNetVal + TKTLines[iLine].NetValue;
    end;{if}

    // Creating an SRF/SCR or an SRC Card Refund, so negate Transaction
    if (TransDocHed = 'SRF') or (TransDocHed = 'SCR')
    or ((TransDocHed = 'SRC') and bCardRefund) then
    begin
      NegateTKTXHeader(TKTXHeader);
      NegateTKTLines(TKTLines, TKTXHeader);
    end;{if}

    // Store Transaction (could be SRC or SRI or SRF or SIN or SOR)
//    LineCount := (LineCount * 2) + 1;

//TKTLines[1].tlQtyPack := 1;

    Result := Ex_StoreTrans(@TKTXHeader,@TKTLines,SizeOf(TKTXHeader),SizeOf(TKTLines),0,B_Insert);
    ShowTKError('Ex_StoreTrans', 21, Result);
    if Result <> 0 then Exit;

    if TXType = ttPartPayment then
      begin
        // If you are paying off part of a TX which you have opened using the "find" function, sTXRefNo is blank {.281}
        if sTXRefNo = ''
        then sTXRefNo := sOriginalTXRefNo;

        if (TenderMode = tmEdit) and (Result = 0) and (DepositMode = fmTakeDeposit)
        then ModifyNotes(sTXRefNo);
      end
    else begin
      sTXRefNo := OurRef; {Return Reference for printing}
      iFolioNum := FolioNum;
      if Result = 0 then AddNotes;
    end;{if}

//    if (Copy(TXRec.TKTXHeader.OurRef,1,3) <> 'SOR') {and (SetupRecord.TransactionType <> 1)} then begin
    if (SetupRecord.TransactionType = TX_SINs) then begin
      // Store Matching information
      if (Result = 0) and (TXType = ttPartPayment) then begin
        {Add link between SRC and SIN}
        with TKMatchRec do begin
          FillChar(TKMatchRec, sizeOf(TKMatchRec), #0);{.297}

          DebitRef := sTXRefNo;
//          DebitRef := TXRec.TKTXHeader.OurRef; // I am sure we need to re-instate this in some way - maybe for SRCs

          CreditRef := OurRef;
          DebitCr := SetupRecord.TillCurrency;
          CreditCr := SetupRecord.TillCurrency;
          DebitVal := InvNetVal; { Value of Debit Amount in Debit Currency }
          CreditVal := InvNetVal; { Value of Credit Amount in Credit Currency }
          BaseVal  := InvNetVal; { Value of Amount Settled in Base Currency }

          {Convert BaseVal into base currency}
          Result := Ex_ConvertAmount(SetupRecord.TillCurrency,0,BaseVal,0);
          ShowTKError('Ex_ConvertAmount', 99, Result);

        end;{with}

        if Result = 0 then begin
          Result := Ex_StoreMatch(@TKMatchRec, SizeOf(TKMatchRec),0,B_Insert);
          ShowTKError('Ex_StoreMatch', 76, Result);
        end;{if}
      end;{if}
    end;{if}

    if (TenderMode = tmAdd) and (DepositMode = fmTakeDeposit)
    then begin
      Result := StoreSerialNumbers;
      if Result = 0 then Result := StoreBinNumbers;
    end;{if}

  end;{with}
end;{StoreTransaction}

// NF: 22/05/2008 {.290} Mods for Tomlinson Parbands
//Function TFrmTender.PrintTX(sTXRefNo : string; iFolioNum : integer) : integer;
Function TFrmTender.PrintTX(sTXRefNo : string; iFolioNum, iCopies : integer) : integer;
var
  iParam : smallint;
  PrBatch : PrintBatchRecType;
  PrnInfo  : TSBSPrintSetupInfo;
  sPrinter : string;
  bReceipt : boolean;
begin
  if PrintBatch_ClearBatch then
    begin

      bReceipt := btnPrinter.Caption = 'Receipt Printer';

      FillChar (PrBatch, SizeOf (PrBatch), #0);
      With PrBatch Do Begin
        { ** This section needs to be built by users }
        pbDefMode   := 1;          { Invoice }
        if bReceipt then pbEFDName := SetupRecord.ReceiptFormName
        else begin
          case SetupRecord.TransactionType of
            TX_SINs : pbEFDName := SetupRecord.InvoiceFormName;  { Invoice Form Name }
            TX_PICKED_SORs, TX_UNPICKED_SORs : pbEFDName := SetupRecord.OrderFormName;  { Invoice Form Name }
          end;{case}
        end;{if}

        pbMainFNum  := InvF;       { Document file InvF }
        pbMainKPath := InvOurRefK; { Our Ref Key }
        pbMainKRef  := sTXRefNo;     { Reference No SIN****** }
        pbTablFNum  := IDetailF;   { Details File IDetailF }
        pbTablKPath := IdFolioK;   { Details Folio Key }
        pbTablKRef  := '****';
        Move (iFolioNum, pbTablKRef[1], 4); { Folio Number }

        // NF: 22/05/2008 {.290} Mods for Tomlinson Parbands
        //pbLbCopies  := 1;
        pbLbCopies  := iCopies;
      End; { With }

      if PrintBatch_AddJob(PrBatch) then
        begin
          if bReceipt then sPrinter := SetupRecord.ReceiptPrinter
          else begin
            case SetupRecord.TransactionType of
              TX_SINs : sPrinter := SetupRecord.InvoicePrinter;
              TX_PICKED_SORs, TX_UNPICKED_SORs : sPrinter := SetupRecord.OrderPrinter;
            end;{case}
          end;{if}

          if RPDev.SelectPrinter(sPrinter, FALSE) then
            begin
              if bReceipt then
                begin
                  RPDev.SelectPaper(RPDev.WalkList(RpDev.Papers, SetupRecord.RecPrintPaper), FALSE);
                  if SetupRecord.RecPrintBin >= 0 then RPDev.SelectBin(RPDev.WalkList(RpDev.Bins, SetupRecord.RecPrintBin), FALSE);
                end
              else begin
                case SetupRecord.TransactionType of
                  TX_SINs : begin
                    RPDev.SelectPaper(RPDev.WalkList(RpDev.Papers, SetupRecord.InvPrintPaper), FALSE);
                    if SetupRecord.InvPrintBin >= 0 then RPDev.SelectBin(RPDev.WalkList(RpDev.Bins, SetupRecord.InvPrintBin), FALSE);
                  end;

                  TX_PICKED_SORs, TX_UNPICKED_SORs : begin
                    RPDev.SelectPaper(RPDev.WalkList(RpDev.Papers, SetupRecord.OrderPrintPaper), FALSE);
                    if SetupRecord.OrderPrintBin >= 0 then RPDev.SelectBin(RPDev.WalkList(RpDev.Bins, SetupRecord.OrderPrintBin), FALSE);
                  end;
                end;{case}

              end;{if}

              PrnInfo := RPDev.SBSSetupInfo;

              PrnInfo.Preview := FALSE;
              For iParam := 1 to ParamCount do begin
                if UpperCase(Paramstr(iParam)) = '/PREVIEW:' then PrnInfo.Preview := TRUE;
              end;{for}

              // NF: 22/05/2008 {.290} Mods for Tomlinson Parbands
//              PrnInfo.NoCopies := 1;
              PrnInfo.NoCopies := iCopies;

              if not PrintBatch_Print('Receipt Print Preview', PrnInfo)
              then MsgBox('PrintBatch_Print Failed.',mtError,[mbOK], mbOK, 'Printing Error');
            end
          else MsgBox('SelectPrinter Failed.',mtError,[mbOK], mbOK, 'Printing Error');
        end
      else MsgBox('PrintBatch_AddJob Failed.',mtError,[mbOK], mbOK, 'Printing Error');
    end
  else MsgBox('PrintBatch_ClearBatch Failed.',mtError,[mbOK], mbOK, 'Printing Error');
end;


procedure TFrmTender.FormCloseQuery(Sender: TObject;  var CanClose: Boolean);
var
  iDeleteLine, iLine : integer;
begin
  if (TenderMode = tmAdd) and (not TXRec.bReversed) then
  begin
    // Remove discounts on lines
    iDeleteLine := -1;
    For iLine := 0 To Pred(FrmTXHeader.lvLines.items.Count) Do
    begin
      with TTXLineInfo(FrmTXHeader.lvLines.Items[iLine].Data).TXLineRec do
      begin
        if (not bMBDLine) then
        begin
          rDiscount3 := 0;
          cDiscount3 := #0;
          iDiscount3Type := 0;
          TKTLRec.tlTransValueDiscount := 0;
          TKTLRec.tlTransValueDiscountChr := #0;
          TKTLRec.tlTransValueDiscountType := 0;
          if bDiscountDescLine then iDeleteLine := iLine
        end;{if}
      end;{with}
    end;{for}

    // Delete desc line for discount
    if iDeleteLine >= 0
    then DeleteLines(FrmTXHeader.lvLines, iDeleteLine);

    // Remove discounts on TX Header
    TXRec.rTTDAmount := 0;
    TXRec.rVBDAmount := 0;
    TXRec.sTransDiscount := '';
    FillChar(TXRec.VBDs, SizeOf(TXRec.VBDs), #0);

    // Recalc
    RecalcAllTXLines(TXRec, FrmTXHeader.lvLines, FALSE);
    RecalcTXTotals(TXRec, FrmTXHeader.lvLines, TRUE);

    // Update Main Form
    FrmTXHeader.UpdateDisplay;
  end;{if}

  {If you have tendered - Always return an "OK" Result}
  if btnTender.Caption = 'OK' then begin
    if {(TXRec.rOutstanding > 0) and} (TenderMode <> tmView) then ModalResult := mrOK
    else ModalResult := mrCancel;
  end;{if}
end;

procedure TFrmTender.edExit(Sender: TObject);
var
  rEditTotal : real;
begin
  with TXRec do begin
{    if (Sender <> nil) then TCurrencyEdit(Sender).Text := RemoveAllChars(TCurrencyEdit(Sender).Text, '-');}
{    if arPayments[pbAccount] <= 0 then arPayments[pbAccount] := 0;}

    rEditTotal := TotaliseEdits;

    arPayments[pbAccount] := rOutstanding - rEditTotal;

    if (rEditTotal > rMoneyToBeTaken) and (rDepositToTake > 0)
    then arPayments[pbAccount] := arPayments[pbAccount] + rEditTotal - rMoneyToBeTaken;

{    if arPayments[pbAccount] < 0 then arPayments[pbAccount] := 0;}

    // cashback on other mops
    if (SetupRecord.CashbackOnOtherMOPs) and (not ZeroFloat(arPayments[pbAccount]))
    and (arPayments[pbAccount] < 0) and ((arPayments[pbCard] + arPayments[pbCheque]) > rMoneyToBeTaken) then
    begin
      arPayments[pbCash] := arPayments[pbCash] + arPayments[pbAccount];
      edCash.Value := arPayments[pbCash];
      arPayments[pbAccount] := 0;
    end;{if}

    lLeftOnAccount.Caption := sCurrencySym + ' ' + MoneyToStr(arPayments[pbAccount]);

    if (Sender <> nil) then begin
      case TCurrencyEdit(Sender).tag of

        1 : begin {edCash}
          if edCash.Value = rMoneyToBeTaken then begin
            edCard.Value := 0;
            edCheque.Value := 0;
          end;{if}
        end;

        2 : begin {edCard}
          if edCard.Value = rMoneyToBeTaken then begin
            edCash.Value := 0;
            edCheque.Value := 0;
          end;{if}
        end;

        3 : begin {edCheque}
          if edCheque.Value = rMoneyToBeTaken then begin
            edCash.Value := 0;
            edCard.Value := 0;
          end;{if}
        end;

      end;{case}
    end;{if}

    if (arPayments[pbAccount] = rMoneyToBeTaken) and (not ZeroFloat(rMoneyToBeTaken)) then
      begin
        case SetupRecord.TransactionType of
          TX_SINs : btnPrinter.Caption := 'Invoice Printer';
          TX_PICKED_SORs, TX_UNPICKED_SORs : btnPrinter.Caption := 'Order Printer';
        end;{case}
      end
    else btnPrinter.Caption := 'Receipt Printer';
  end;{with}

  if ActiveControl <> btnPrinter then SendMessage(btnPrinter.Handle,CM_MOUSEENTER,0,0); {redraw button}

  edChange(nil);
end;

procedure TFrmTender.EnableDisable;
begin
  with TXRec do begin
    case DepositMode of
      fmTakeDeposit : begin
        edCash.Enabled := (not ZeroFloat(rOutstanding)) and (TenderMode <> tmView);
        edCard.Enabled := (not ZeroFloat(rOutstanding)) and (TenderMode <> tmView);
        edCheque.Enabled := (not ZeroFloat(rOutstanding)) and (TenderMode <> tmView);
        btnCash.Enabled := (not ZeroFloat(rOutstanding)) and (TenderMode <> tmView);
        btnCard.Enabled := (not ZeroFloat(rOutstanding)) and (TenderMode <> tmView);
        btnCheque.Enabled := (not ZeroFloat(rOutstanding)) and (TenderMode <> tmView);
    {    btnSettDiscount.Enabled := btnSettDiscount.Visible and (TenderMode = tmAdd);}
        if {ZeroFloat(rOutstanding) or} (TenderMode = tmView) then
        begin
          btnTender.Caption := 'OK';
          btnTender.Cancel := TRUE;
          SendMessage(btnTender.Handle,CM_MOUSEENTER,0,0); {redraw button}
          btnReprint.Visible := TRUE;
        end;{if}
      end;

      fmOnAccount : begin
        edCash.Enabled := (not bCardRefund);
        edCard.Enabled := TRUE;
        edCheque.Enabled := (not bCardRefund);
        btnCash.Enabled := (not bCardRefund);
        btnCard.Enabled := TRUE;
        btnCheque.Enabled := (not bCardRefund);
      end;
    end;{case}
  end;{with}
end;

procedure TFrmTender.edChange(Sender: TObject);
begin
  with TXRec do begin
    case DepositMode of
      fmTakeDeposit : begin
        btnTender.Enabled := ((TenderMode = tmAdd) or (TenderMode = tmView) or (TotaliseEdits > 0))
        and (((not bRefund) and (rTendered >= 0)) or ((bRefund) and (rTendered <= 0)));
      end;

      fmOnAccount : begin
        btnTender.Enabled := TotaliseEdits = rDepositToTake;
      end;
    end;{case}
  end;{with}
end;

procedure TFrmTender.btnSettDiscountClick(Sender: TObject);
begin
  if TenderMode = tmAdd then begin
    with TXRec do begin
      TKTXHeader.DiscTaken := not TKTXHeader.DiscTaken;

      rOutstanding := rVATIncTotal - rDepositsTaken - rWrittenOff
      - (TKTXHeader.DiscSetAm * WordBoolOrd(TKTXHeader.DiscTaken))
      - rTTDAmount - rVBDAmount;

      lOutstanding.Caption := sCurrencySym + ' ' + MoneyToStr(rOutstanding);

      if ZeroFloat(rDepositToTake) then rMoneyToBeTaken := rOutstanding
      else rMoneyToBeTaken := rDepositToTake;
      edExit(nil);

      if TKTXHeader.DiscTaken then lSettDiscount.Caption := 'Taken'
      else lSettDiscount.Caption := 'Not Taken';
    end;{with}
{    ActiveControl := edCash; {it crashes if you try to do the next line, with the active control on the button}
{    SendMessage(btnSettDiscount.Handle,CM_MOUSEENTER,0,0); {redraw button}
  end;{if}
end;

function TFrmTender.StoreNote(TKTXNotes : TBatchNotesRec; iLineNo : byte; sLine : string; bInsert : Boolean): smallint;
var
  iRecAddress : integer;
begin
  Result := Ex_GetRecordAddress(8,iRecAddress);
  ShowTKError('Ex_GetRecordAddress', 122, Result);
  if Result = 0 then begin
    with TKTXNotes do begin
      LineNo := iLineNo;
      NoteLine := sLine;
      if bInsert then Result := Ex_StoreNotes(@TKTXNotes,SizeOf(TKTXNotes),0,B_Insert)
      else Result := Ex_StoreNotes(@TKTXNotes,SizeOf(TKTXNotes),0,B_Update);
      ShowTKError('Ex_StoreNotes', 78, Result);
    end;{with}
    Result := Ex_GetRecWithAddress(8,0,iRecAddress);
    ShowTKError('Ex_GetRecWithAddress', 123, Result);
  end;{if}
end;

function TFrmTender.AddNotes : SmallInt;
var
  TKTXNotes : TBatchNotesRec;
begin
  Result := 0;
  FillChar(TKTXNotes, SizeOf(TKTXNotes), #0);
  with TKTXNotes, TXRec do begin
    NoteCode := TKTXHeader.OurRef;
    NoteSort := 'DOC';
    NoteType := '2';

    if Result = 0 then Result := StoreNote(TKTXNotes, 1,'Tender Details :-', TRUE);
    if Result = 0 then Result := StoreNote(TKTXNotes, 2,'Cash :              ' + sCurrencySym + MoneyToStr(arPayments[pbCash]), TRUE);
    if Result = 0 then Result := StoreNote(TKTXNotes, 3,'Card :              ' + sCurrencySym + MoneyToStr(arPayments[pbCard]), TRUE);
    if Result = 0 then Result := StoreNote(TKTXNotes, 4,'Cheque :            ' + sCurrencySym + MoneyToStr(arPayments[pbCheque]), TRUE);
    if Result = 0 then Result := StoreNote(TKTXNotes, 5,'Left On Account :   ' + sCurrencySym + MoneyToStr(arPayments[pbAccount]), TRUE);
    if Result = 0 then Result := StoreNote(TKTXNotes, 6,'Written-Off :       ' + sCurrencySym + MoneyToStr(rWrittenOff), TRUE);
    if Result = 0 then Result := StoreNote(TKTXNotes, 7,'Change :            ' + sCurrencySym + MoneyToStr(rChange), TRUE);
    if Result = 0 then Result := StoreNote(TKTXNotes, 8,'Outstanding :       ' + sCurrencySym + MoneyToStr(rOutstanding), TRUE);
    if (Result = 0) and (sOverrideUsername <> '') then Result := StoreNote(TKTXNotes, 9,'Override User : ' + sOverrideUsername, TRUE);
  end;{with}
end;

function TFrmTender.ModifyNotes(sDoc : string) : SmallInt;
var
  TKTXNotes : TBatchNotesRec;
  pFind : pChar;
  iStatus : smallint;
begin
  Result := 0;
  pFind := StrAlloc(255);
  FillChar(TKTXNotes, SizeOf(TKTXNotes), #0);
  with TKTXNotes, TXRec do begin
    NoteCode := sDoc;
    NoteSort := 'DOC';
    NoteType := '2';
    strPCopy(pFind, sDoc);
    iStatus := Ex_GetNotes(@TKTXNotes,SizeOf(TKTXNotes), pFind, 0, B_GetGEq, TRUE);
    if (iStatus = 30002) then {.223}
    else begin
      if iStatus <> 9 then ShowTKError('Ex_GetNotes', 77, iStatus);
      while (iStatus = 0) and (TKTXNotes.NoteCode = sDoc) do begin

        case TKTXNotes.LineNo of
          2 : if Result = 0 then Result := StoreNote(TKTXNotes, 2,'Cash :              ' + sCurrencySym
          + MoneyToStr(arPayments[pbCash]), FALSE);
          3 : if Result = 0 then Result := StoreNote(TKTXNotes, 3,'Card :              ' + sCurrencySym
          + MoneyToStr(arPayments[pbCard]), FALSE);
          4 : if Result = 0 then Result := StoreNote(TKTXNotes, 4,'Cheque :            ' + sCurrencySym
          + MoneyToStr(arPayments[pbCheque]), FALSE);
          5 : if Result = 0 then Result := StoreNote(TKTXNotes, 5,'Left On Account :   ' + sCurrencySym
          + MoneyToStr(arPayments[pbAccount]), FALSE);
          6 : if Result = 0 then Result := StoreNote(TKTXNotes, 6,'Written-Off :       ' + sCurrencySym
          + MoneyToStr(rWrittenOff), FALSE);
          7 : if Result = 0 then Result := StoreNote(TKTXNotes, 7,'Change :            ' + sCurrencySym
          + MoneyToStr(rChange), FALSE);
          8 : if Result = 0 then Result := StoreNote(TKTXNotes, 8,'Outstanding :       ' + sCurrencySym
          + MoneyToStr(rOutstanding), FALSE);
        end;{case}

        iStatus := Ex_GetNotes(@TKTXNotes,SizeOf(TKTXNotes), pFind, 0, B_GetNext, TRUE);
        if (iStatus <> 9) and (iStatus <> 30002) then ShowTKError('Ex_GetNotes', 77, iStatus);
      end;{while}
    end;{if}
  end;{with}
  StrDispose(pFind);
end;


procedure TFrmTender.btnReprintClick(Sender: TObject);
var
  iCopies : integer;
begin
  if btnReprint.Visible and btnReprint.Enabled then begin
    ActiveControl := btnReprint;
    // NF: 22/05/2008 {.290} New Custom Event for Tomlinson Parbands
    // PrintTX(TXRec.TKTXHeader.OurRef, TXRec.iFolioNum);
    iCopies := 1;
    HOOK_TenderBeforePrint(iCopies);
    if iCopies > 0 then PrintTX(TXRec.TKTXHeader.OurRef, TXRec.iFolioNum, iCopies);
  end;{if}
end;

procedure TFrmTender.btnPrinterClick(Sender: TObject);
begin
  ActiveControl := btnPrinter;

  if btnPrinter.Caption = 'Receipt Printer' then
    begin
      case SetupRecord.TransactionType of
        TX_SINs : btnPrinter.Caption := 'Invoice Printer';
        TX_PICKED_SORs, TX_UNPICKED_SORs : btnPrinter.Caption := 'Order Printer';
      end;{case}
    end
  else btnPrinter.Caption := 'Receipt Printer';

end;

procedure TFrmTender.FormCreate(Sender: TObject);
begin
  if SysColorMode in ValidColorSet then DrawFormBackground(self, bitFormBackground);
  edCash.DisplayFormat := '#########0.00';
  edCard.DisplayFormat := '#########0.00';
  edCheque.DisplayFormat := '#########0.00';
  DepositMode := fmTakeDeposit;

  // get custom text for Cash button
  btnCash.Caption := Trim(TradeCustomisation.CustomText (twiTender, ctTenderMOPButton1, btnCash.Caption));
  SendMessage(btnCash.Handle,CM_MOUSEENTER,0,0); {redraw button}

  // get custom text for Card button
  btnCard.Caption := Trim(TradeCustomisation.CustomText (twiTender, ctTenderMOPButton2, btnCard.Caption));
  SendMessage(btnCard.Handle,CM_MOUSEENTER,0,0); {redraw button}

  // get custom text for Cheque button
  btnCheque.Caption := Trim(TradeCustomisation.CustomText (twiTender, ctTenderMOPButton3, btnCheque.Caption));
  SendMessage(btnCheque.Handle,CM_MOUSEENTER,0,0); {redraw button}

  // Apply VBD
  if TenderMode = tmAdd then ApplyVBD;
end;

// NF: 22/05/2008 {.290} New Custom Event for Tomlinson Parbands
function TFrmTender.HOOK_TenderBeforePrint(var iCopies : integer) : boolean;
var
  CurrentLineRec : TTXLineRec;
  bReceipt : boolean;
begin{HOOK_TenderBeforePrint}
  Result := TRUE;
  {$IFDEF TCCU}  // Trade Counter Customisation
    // Check to see if the event has been enabled by a Plug-In
    if TradeCustomisation.GotEvent(twiTender, hpTenderBeforePrint) then
    begin

      FillChar(CurrentLineRec, SizeOf(CurrentLineRec), #0);

      // Update EventData with current data values
      TradeCustomisation.EventDataO.Assign(Self.Handle, twiTender, hpTenderBeforePrint
      , TXRec, FrmTXHeader.lvLines, TKLocationRecord, CurrentLineRec, TKPayLines, FrmTXHeader);

      // Default Copies
      TradeCustomisation.EventDataO.aLongResult[1] := SetupRecord.TransactionType;
      TradeCustomisation.EventDataO.aLongResult[2] := iCopies;

      // Default FormName from SystemSetup
      bReceipt := btnPrinter.Caption = 'Receipt Printer';
      if bReceipt then
      begin
        TradeCustomisation.EventDataO.aStringResult[1] := SetupRecord.ReceiptFormName;
      end
      else
      begin
        case SetupRecord.TransactionType of
          TX_SINs : TradeCustomisation.EventDataO.aStringResult[1] := SetupRecord.InvoiceFormName;
          TX_PICKED_SORs,TX_UNPICKED_SORs : TradeCustomisation.EventDataO.aStringResult[1] := SetupRecord.OrderFormName;
        end;{case}
      end;{if}

      // Execute the Hook Point Event
      TradeCustomisation.ExecuteEvent;

      // Set the FormName according to the value in StringResult[1]
      if bReceipt then
      begin
        SetupRecord.ReceiptFormName := TradeCustomisation.EventDataO.aStringResult[1];
      end
      else
      begin
        case SetupRecord.TransactionType of
          TX_SINs : SetupRecord.InvoiceFormName := TradeCustomisation.EventDataO.aStringResult[1];
          TX_PICKED_SORs,TX_UNPICKED_SORs : SetupRecord.OrderFormName := TradeCustomisation.EventDataO.aStringResult[1];
        end;{case}
      end;{if}

      iCopies := TradeCustomisation.EventDataO.aLongResult[2];

    end; { If TradeCustomisation.GotEvent... }
  {$ENDIF}
end;{HOOK_TenderBeforePrint}

procedure TFrmTender.btnTransDiscountClick(Sender: TObject);
var
  oTTDCalculator : TTTDCalculator;
  bResyncPayments : boolean;
  iLine, iAllocate : integer;
  edAllocate : TCurrencyEdit;
begin
  if btnTransDiscount.enabled then
  begin
    bResyncPayments := ZeroFloat(TXRec.arPayments[pbAccount]);

    // Create TTD Calc object
    oTTDCalculator := TTTDCalculator.Create(TenderMode = tmAdd, TXRec, FrmTXHeader.lvLines);
    oTTDCalculator.AllowSaleBelowCost := aAllowedTo[atSellAtLessThanCost];
    oTTDCalculator.AllowDiscountToExceedSale := aAllowedTo[atDiscountToExceedSale];

    // Display TTD Offer dlg
  //  OfferTTD(Owner, SampleControl, oTTDCalculator);
    if OfferTTD(Owner, nil, oTTDCalculator) then
    begin
      // read in changes made by TTD Calculator.
      TXRec := oTTDCalculator.TXRec;
  //    CopyListViewItems(oTTDCalculator.ListView.Items, FrmTXHeader.lvLines.Items);

      if ZeroFloat(TXRec.rTTDAmount) then ApplyVBD; // Apply VBD when removing TTD

      // refreshes the screens
      FrmTXHeader.UpdateDisplay;
      PopulateForm(TXRec);

      // Trys to intelligently fill one of the MOP amounts with the new amount
      if bResyncPayments then
      begin

        edExit(nil);// repopulates the "left on account"

        iAllocate := Ord(Low(TPayedBy));
        for iLine := Ord(Low(TPayedBy))+1 to Ord(pbCheque) do
        begin
          if TXRec.arPayments[TPayedBy(iLine)] > TXRec.arPayments[TPayedBy(iLine-1)]
          then iAllocate := iLine;
        end;{for}

        case TPayedBy(iAllocate) of
          pbCash : edAllocate := edCash;
          pbCard : edAllocate := edCard;
          pbCheque : edAllocate := edCheque;
        end;

        edAllocate.Value := StrToFloatDef(edAllocate.Text, 0) + TXRec.arPayments[pbAccount];
      end;{if}

      edExit(nil);// repopulates the "left on account"
    end;{if}

    // Clear up
    FreeAndNIL(oTTDCalculator);
  end;{if}
end;

procedure TFrmTender.PopulateForm(var TheTXRec: TTXRec);
var
  bImplementVBDs : boolean;

  function ImplementTTDs(rNetTotal, rTTDValue : double) : boolean;
  begin{ImplementTTDs}
    Result := TRUE;

    // Check if we are about to create an SRF/SCR, which TTDs do not get implemented on.
    if (SetupRecord.NegativeTXType = 1) {Create SRFs and SCRs}
    and (rNetTotal < 0) and (not zerofloat(rNetTotal)) then
    begin
      Result := FALSE;
      exit;
    end;{if}

    // Check if TTD Has been disabled in Exchequer
    if (not TKSysRec.TTDEnabled) {VBD Disabled} then
    begin
      Result := FALSE;
      exit;
    end;{if}

    // Check if we are in the correct discount mode
{    if (SetupRecord.DiscountType <> 1) then {not "Use and modify Exchequer Discounts"}
{    begin
      Result := FALSE;
      exit;
    end;{if}
  end;{ImplementTTDs}

begin
  with TheTXRec do
  begin
    if ZeroFloat(rDepositToTake) then rMoneyToBeTaken := rOutstanding
    else rMoneyToBeTaken := rDepositToTake;

    bRefund := rMoneyToBeTaken < 0;

    if bRefund then
    begin
      lNet.Caption := '';
      lOrigNetTit.Enabled := FALSE;
    end else
    begin
      lNet.Caption := sCurrencySym + ' ' + MoneyToStr(rOrigNetTotal);
    end;{if}

//    lNet.Caption := sCurrencySym + ' ' + MoneyToStr(rNetTotal);
    lVAT.Caption := sCurrencySym + ' ' + MoneyToStr(TKTXHeader.InvVat);
    lAmount.Caption := sCurrencySym + ' ' + MoneyToStr(rVATIncTotal);

    lDeposits.Caption := sCurrencySym + ' ' + MoneyToStr(rDepositsTaken);

    // VBD
    if ImplementVBDs(rNetTotal, TheTXRec.rTTDAmount)
    or ((TenderMode = tmEdit) and (not TheTXRec.bFindModeTTD)) then
    begin
      lValueDiscount.Caption := sCurrencySym + ' ' + MoneyToStr(rVBDAmount);

      if VBDs.cCurrentVBD = #0 then
      begin
        lVBDTit.Caption := '- Current VBD @ ' + sCurrencySym + MoneyToStr(VBDs.rCurrentVBDThreshold);
      end else
      begin
        lVBDTit.Caption := '- Current VBD @ ' + sCurrencySym + MoneyToStr(VBDs.rCurrentVBDThreshold)
        + ' = ' + VBDs.sCurrentVBD;
      end;{if}

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

    lTransDiscount.Caption := sCurrencySym + ' ' + MoneyToStr(rTTDAmount);
    if sTransDiscount = ''
    then lTTDPercent.Caption := ''
    else lTTDPercent.Caption := '(' + sTransDiscount + ')';

    btnTransDiscount.Enabled := (TenderMode = tmAdd) and ImplementTTDs(rNetTotal, TheTXRec.rTTDAmount) and (not bRefund);
    lTransDiscount.Enabled := ImplementTTDs(rNetTotal, TheTXRec.rTTDAmount) and (not bRefund);

    lVBD.Enabled := bImplementVBDs and (not bRefund);
    lValueDiscount.Enabled := bImplementVBDs and (not bRefund);
    lVBDTit.Enabled := bImplementVBDs and (not bRefund);
    lNextVBDTit.Enabled := bImplementVBDs and (not bRefund);

//    lNetAfterDisc.Caption :=sCurrencySym + ' ' + MoneyToStr(rNetTotalAfterDisc);
//    lNetAfterDisc.Caption :=sCurrencySym + ' ' + MoneyToStr(rNetTotal);
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

  end;{with}
end;

Procedure TFrmTender.ApplyVBD;
var
  oTTDCalculator : TTTDCalculator;
  iLine : integer;
begin
  // VBD
  if ImplementVBDs(TXRec.rNetTotal, TXRec.rTTDAmount) then
  begin
    TXRec.VBDs := GetVBDs(TXRec.TKTXHeader.CustCode, TXRec.rNetTotal);

    if (not ZeroFloat(TXRec.VBDs.rCurrentVBD)) then
    begin
      // Create TTD Calc object
      oTTDCalculator := TTTDCalculator.Create(TenderMode = tmAdd, TXRec, FrmTXHeader.lvLines);
      oTTDCalculator.AllowSaleBelowCost := aAllowedTo[atSellAtLessThanCost];
      oTTDCalculator.AllowDiscountToExceedSale := aAllowedTo[atDiscountToExceedSale];
      oTTDCalculator.DiscountMode := cdmVBD;

      // Calc VBD
      oTTDCalculator.CalculateAD(TXRec.VBDs.rCurrentVBD, TXRec.VBDs.cCurrentVBD);
      oTTDCalculator.UpdateTransactionDiscounts(TRUE);
      TXRec := oTTDCalculator.TXRec;
      TXRec.rVBDAmount := oTTDCalculator.TransTotals[ttBeforeNetTotal] - oTTDCalculator.TransTotals[ttAfterNetTotal];
      if (not Zerofloat(TXRec.rVBDAmount)) then TXRec.rTTDAmount := 0;

{      For iLine := 0 To Pred(oTTDCalculator.ListView.Items.Count) Do
      begin
        // update line discount amount
        TTXLineInfo(oTTDCalculator.ListView.Items[iLine].Data).TXLineRec.rLineValueDiscount
        := ABS(Round_Up(TTTDCalculatorLine(oTTDCalculator.ListView.Items[iLine]).LineTotals[ltBeforeNetTotal]
        - TTTDCalculatorLine(oTTDCalculator.ListView.Items[iLine]).LineTotals[ltAfterNetTotal], 2));
      end;{for}

      // Update Main Window
      FrmTXHeader.UpdateDisplay;

      // Clear up
      FreeAndNIL(oTTDCalculator);
    end;{if}
  end else
  begin
    TXRec.rVBDAmount := 0;
  end;{if}
end;


end.
