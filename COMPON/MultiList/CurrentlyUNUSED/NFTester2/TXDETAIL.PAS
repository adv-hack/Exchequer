unit TXDetail;

{ nfrewer440 09:08 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, ExtCtrls
  , SBSPanel, BTSupU1, SBSComp, GlobVar, BTList, VarConst, NeilProc, CardProc, BTKeys1U,
  ETDateU, ExWrap1U, TEditVal, Mask, DLLProc, Comms, BtrvU2, ExchLink, StrUtil, APIUtil
  , TCustom;

type
  TTXDetailList = class(TMULCtrl)
    public
{      iTotDiscount : integer;}
      function SetCheckKey : Str255; override;
      function SetFilter : Str255; override;
      function OutLine(Col : Byte) : Str255; override;
  end;{TTXDetailList}

  TTXType = (ttPaidIn, ttSpent);

  TFrmTXDetails = class(TForm)
    panButtons: TSBSPanel;
    btnOK: TSBSButton;
    btnCancel: TSBSButton;
    btnClose: TSBSButton;
    Bevel2: TBevel;
    Label4: TLabel;
    lRefNo: TLabel;
    Label8: TLabel;
    edDate: TEditDate;
    cmbPaytype: TSBSComboBox;
    Label13: TLabel;
    Label11: TLabel;
    lEqValue: TLabel;
    Label10: TLabel;
    edIncentive: TCurrencyEdit;
    edReceived: TCurrencyEdit;
    Label9: TLabel;
    Bevel3: TBevel;
    Label15: TLabel;
    edComments: Text8Pt;
    Bevel4: TBevel;
    sbMain: TScrollBox;
    panDesc: TSBSPanel;
    panDiscPer: TSBSPanel;
    panTitle: TSBSPanel;
    panDescTit: TSBSPanel;
    panQtyTit: TSBSPanel;
    panDiscountTit: TSBSPanel;
    panCostTit: TSBSPanel;
    panDiscPerTit: TSBSPanel;
    panDiscount: TSBSPanel;
    panQty: TSBSPanel;
    panCost: TSBSPanel;
    panScrollBar: TSBSPanel;
    Label12: TLabel;
    ltotdistit: TLabel;
    lTotDiscount: TLabel;
    btnAdd: TSBSButton;
    btnEdit: TSBSButton;
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure panDescMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure panDescTitMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure panDescTitMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure edReceivedExit(Sender: TObject);
    procedure btnDCloseClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure edIncentiveEnter(Sender: TObject);
  private
    FormStuff : TFormStuff;
    ExLocal : TdExLocal;
{    iTotalAmount : integer;}
    bFormClosing : boolean;
    rPrevRate : Real;
    TXType : TTXType;
    procedure WMGetMinMaxInfo(var message : TWMGetMinMaxInfo); message WM_GetMinMaxInfo;
    procedure RefreshTXDetails;
    procedure ChangeFormMode(NewMode : TFormMode);
    function SaveTXDetails : boolean;
    procedure Form2Inv;
    procedure Inv2Form;
  public
    bValidLine : boolean;
    iTotDiscount : integer; 
    FormMode : TFormMode;
    procedure UpdateDetails(PrevFormEXLocal : TdEXLocal; NewMode : TFormMode);
  end;

{var
  FrmTXDetails: TFrmTXDetails;}

implementation

uses Cardlist;

{$R *.DFM}


{TTXDetailList}

function TTXDetailList.SetCheckKey : Str255;
begin
  SetCheckKey := FullNomKey(SalesDetRec.sdFolioNum);
end;

function TTXDetailList.SetFilter  :  Str255;
begin
  Result := '';
end;

function TTXDetailList.OutLine(Col : Byte) : Str255;
{defines which fields go in which columns}
var
  iDiscount : integer;
begin
  with SalesDetRec do begin
    case Col of
      0 : OutLine := sdName;                                 {Item Description}
      1 : OutLine := PenceToStr(PenceIt(sdQuantity));        {Quantity}
      2 : OutLine := PenceToStr(PenceIt(sdValue));           {Cost}
      3 : OutLine := PenceToStr(PenceIt(sdDiscRate));        {Discount %}
      4 : begin                                              {Discount}
        iDiscount := PenceIt(sdDiscount);
        OutLine := PenceToStr(iDiscount);
{        iTotDiscount := iTotDiscount + iDiscount;}
      end;
    else OutLine := '';
    end;{case}
  end;{with}
end;


{TFrmTXDetails}

procedure TFrmTXDetails.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmTXDetails.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  iMResult : byte;
begin
  if not bFormClosing then begin
    bFormClosing := TRUE;
    if FormMode <> fmView then begin
      iMResult := MsgBox('You are currently editing a record.' + #13 + #13
      + 'Do you wish to save the changes that you have made to this record ?',mtConfirmation, [mbYes,mbNo],mbYes,'Ledger Record');
      case iMResult of
        mrYes : btnOKClick(Self);
        mrNo : btnCancelClick(Self);
      end;{case}
    end;{if}
    SendMessage(TForm(Owner).Handle,WM_FormCloseMsg,1,0);
    Action := caFree;
  end;{if}
end;

procedure TFrmTXDetails.FormCreate(Sender: TObject);
begin
  bFormClosing := FALSE;
  ExLocal.Create; {create local record instance for independant data manipulation}
  FormStuff := TFormStuff.Create(1);
  with FormStuff do begin
    SetLength(aColumns[0],5);
    aColumns[0,0].ColPanel := panDesc;
    aColumns[0,0].HeadPanel := panDescTit;
    aColumns[0,1].ColPanel := panQty;
    aColumns[0,1].HeadPanel := panQtyTit;
    aColumns[0,1].DecPlaces := 2;
    aColumns[0,2].ColPanel := panCost;
    aColumns[0,2].HeadPanel := panCostTit;
    aColumns[0,2].DecPlaces := 2;
    aColumns[0,3].ColPanel := panDiscPer;
    aColumns[0,3].HeadPanel := panDiscPerTit;
    aColumns[0,3].DecPlaces := 2;
    aColumns[0,4].ColPanel := panDiscount;
    aColumns[0,4].HeadPanel := panDiscountTit;
    aColumns[0,4].DecPlaces := 2;

    aFileNos[0] := SalesDetF;
{    asbMain[0] := sbMain;}
    asbMain[0] := sbMain;
    acPrimeKeys[0] := 'I';
    apanTitle[0] := panTitle;
{    asbButtons[0] := sbButtons;
    apanButtons[0] := panButtons;}
    asbButtons[0] := nil;
    apanButtons[0] := nil;
    aMULCtrlO[0] := TTXDetailList.Create(Self);{creates control object}
    apanScrollBar[0] := panScrollBar;
    aCaseSensSearch[0] := TRUE;
    aiKeys[0] := sdFolioK;

    TXType := ttSpent;
    Self.ClientHeight := 369;
    Self.ClientWidth := 521;
    ReadFormProperties(Self, FormStuff);
    Self.ClientHeight := 159;
    aMULCtrlO[0].ReColorBar(panScrollBar.Font,clNavy);
    FormResize(Self);
  end;{with}
end;

procedure TFrmTXDetails.FormResize(Sender: TObject);
begin
  DoFormResize(Self, FormStuff);
end;

procedure TFrmTXDetails.WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo);
{sets the minimum size of window (enforced real-time)}
begin
  with Message.MinMaxInfo^ do begin
    case TXType of
      ttSpent : begin
        ptMinTrackSize.X := 505;
        ptMinTrackSize.Y := 323;
      end;

      ttPaidIn : begin
        ptMinTrackSize.X := 505;
        ptMinTrackSize.Y := 186;
        ptMaxTrackSize.X := 505;
        ptMaxTrackSize.Y := 186;
      end;
    end;{case}
  end;{with}
  Message.Result := 0;
  inherited;
end;

procedure TFrmTXDetails.panDescMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Sender is TSBSPanel) then DoMoveAlignCols(TSBSPanel(Sender), FormStuff, 0);
end;

procedure TFrmTXDetails.panDescTitMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  {depresses the column header}
  if (Sender is TSBSPanel) and (not TSBSPanel(Sender).ReadytoDrag) and (Button = MBLeft)
  then FormStuff.aMULCtrlO[0].VisiList.PrimeMove(Sender); {begin column drag/drop}
end;

procedure TFrmTXDetails.panDescTitMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  {visually moves column header to show the change about to be made (drag/drop}
  if (Sender is TSBSPanel) then FormStuff.aMULCtrlO[0].VisiList.MoveLabel(X,Y);
end;

procedure TFrmTXDetails.FormDestroy(Sender: TObject);
begin
  ExLocal.Destroy;
  FormStuff.Free;
end;

procedure TFrmTXDetails.UpdateDetails(PrevFormEXLocal : TdEXLocal; NewMode : TFormMode);
begin
  with ExLocal do begin
    if FormMode = fmView then begin
      LCust := PrevFormEXLocal.LCust;
      LInv := PrevFormEXLocal.LInv;
      LGetRecAddr(CustF);
      LGetRecAddr(InvF);
      LastInv := LInv;
    end;{if}

    case NewMode of
      fmView, fmEdit : begin
        {fills details}

        RefreshTXDetails;
        if bValidLine then
          begin
            Inv2Form;
{            CalcInvoiceCredits(LInv, iTotalAmount, iIncentive, iCrInc, iCredits, iBalance,TRUE);
            if (iTotalAmount = 0) then TXType := ttPaidIn
            else TXType := ttSpent;}
          end
        else begin
      {   lCardNo.Caption := '';}
      {   lCardName.Caption := '';}
          edDate.Text := '';
          lRefNo.Caption := '';
      {   lTotalAmount.Caption := '';}
          cmbPaytype.ItemIndex := -1;
          edComments.Text := '';
          edReceived.Value := 0;
          edIncentive.Value := 0;
          lEqValue.Caption := '0.00';
          if TXType = ttPaidIn then lTotDiscount.Caption := '0.00';
        end;{if}

      end;

      fmAdd : begin
        edDate.DateValue := Today;
        lRefNo.Caption := '';
        cmbPaytype.ItemIndex := 0;
        edReceived.Value := 0;
        lEQValue.Caption := '0.00';
        lTotDiscount.Caption := '0.00';
        edComments.Text := '';

        {set default incentive}
        if (not Syss.UseSplDisc) then
          begin
            if (LCust.LastDisc <> 0) And (Not Syss.UseMarkup) then edIncentive.Value := LCust.LastDisc
            else edIncentive.Value := Syss.Markup
          end
        else edIncentive.Value := 0; { Using Split Discounts - no incentive on receipts }
      end;
    end;{case}
  end;{with}
  ChangeFormMode(NewMode);
end;

procedure TFrmTXDetails.RefreshTXDetails;
var
  KeyStart : Str255;
  Incentive, Debits, Credits, Balance : real;
begin
  with TTXDetailList(FormStuff.aMULCtrlO[0]), ExLocal.LInv do begin
{    iTotDiscount := 0;}
    KeyStart := FullNomKey(FolioNum);
    if KeyStart <> '' then StartList(SalesDetF,sdFolioK,KeyStart,'','',Length(KeyStart), FALSE);

    if Copy(OurRef,1,3) = 'SOR' then TXType := ttSpent
    else TXType := ttPaidIn;

    if TXType = ttSpent then
      begin
{        BorderIcons := BorderIcons + [biMaximize];}
        CalcInvoiceCredits(ExLocal.LInv, Debits, Incentive, Credits, Balance);
        lTotDiscount.Caption := MoneyToStr(Incentive);
      end
    else {BorderIcons := BorderIcons - [biMaximize]};
  end;{with}
end;

procedure TFrmTXDetails.edReceivedExit(Sender: TObject);
begin
  if FormMode <> fmView then begin
    if TCurrencyEdit(Sender).Name = 'edIncentive' then begin
      if (edIncentive.Value <> Syss.MarkUp) and (edIncentive.Value <> rPrevRate)
      then begin
        if MsgBox('Please confirm this incentive rate : ' + edIncentive.Text + '%'
        ,mtConfirmation,[mbOK, mbCancel],mbOK,'Confirm Discount') = mrCancel
        then edIncentive.Value := rPrevRate;
      end;{if}
    end;{if}

    with ExLocal, LInv do begin
      InvNetVal := edReceived.Value;
      if (Syss.VatMode = vmAdv) then InvDocHed := SRI
      else InvDocHed := NMT;
      DiscAmount := 0;
      Discount := edIncentive.Value;

      if TXType = ttPaidIn then begin
        lTotDiscount.Caption := PenceToStr(Round(Calc_InvDisc(LInv,Pro_RataDisc(ExLocal.LInv, LInv, LCust)) * -100));
        lEqValue.Caption := PenceToStr(PenceIt(edReceived.Value) + StrToPence(lTotDiscount.Caption));
      end;{if}
    end;{with}
  end{if}
end;

procedure TFrmTXDetails.btnDCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmTXDetails.btnOKClick(Sender: TObject);
var
  PrevFormMode : TFormMode;
begin
  SaveTXDetails;
  {  SendMessage(FrmComms.Handle,WM_MPComms,mpcGetBalance,ExLocal.LCust.TillNo); SHOULDN't NEED THIS AS THE LINE BELOW SHOULD TAKE CARE OF IT}
  SendMessage(TForm(Owner).Handle,WM_CustGetRec,200,0);{update details}
  PrevFormMode := FormMode;
  ChangeFormMode(fmView);
  if PrevFormMode = fmAdd then Close;
end;

procedure TFrmTXDetails.ChangeFormMode(NewMode : TFormMode);
begin
  FormMode := NewMode;
  Case FormMode of
    fmEdit : begin
      if LockRecord(InvF, InvCustK, EXLocal, TRUE) then Caption := 'Edit Transaction Details'
      else FormMode := fmView;
    end;

    fmView : begin
      Caption := 'View Transaction Details';
      LockRecord(InvF, InvCustK, EXLocal, FALSE);
    end;

    fmAdd : begin
      Caption := 'Add New Receipt';

      TXType := ttPaidIn;
      ClientHeight := 159;
      ClientWidth := 497;

      ResetRec(InvF);
      with ExLocal, LInv do begin

        if (Syss.VatMode = vmAdv) then InvDocHed := SRI
        else InvDocHed := NMT;

        CustCode := LCust.CustCode;
        PrevBal := LCust.CurrBalance;

        {$IFDEF Ex_On}
          SetNextDocNos(LInv,FALSE);
        {$ENDIF}

        if (not Syss.UseSplDisc) Then
          begin
            { Using Incentive on receipts }
            if (LCust.LastDisc <> 0) and (not Syss.UseMarkup) then Discount := LCust.LastDisc
            else Discount := Syss.Markup;
          end
        else Discount := 0.0;{Using Split Discounts - no incentive on receipts}

      end;{with}
    end;
  end;{case}

  btnOK.Enabled := FormMode <> fmView;
  btnCancel.Enabled := FormMode <> fmView;
  btnClose.Enabled := FormMode = fmView;
  btnAdd.Enabled := FormMode = fmView;
  btnEdit.Enabled := (FormMode = fmView) and bValidLine and (ExLocal.Linv.RunNo = 0);

  edDate.ReadOnly := FormMode = fmView;
  cmbPayType.ReadOnly := FormMode = fmView;
  edReceived.ReadOnly := FormMode = fmView;
  edIncentive.ReadOnly := FormMode = fmView;
  edComments.ReadOnly := FormMode = fmView;

  if btnAdd.Enabled then btnAdd.Enabled := bgCommsWorking and (LoginMode <> lmOperator);
  if btnEdit.Enabled then btnEdit.Enabled := bgCommsWorking and (LoginMode <> lmOperator);
end;

procedure TFrmTXDetails.btnCancelClick(Sender: TObject);
begin
  Case FormMode of
    fmEdit : begin
      ChangeFormMode(fmView);
      SendMessage(TForm(Owner).Handle,WM_FormCloseMsg,1001,0);
    end;

    fmAdd : begin
      ChangeFormMode(fmView);
      Close;
    end;
  end;{case}
end;

procedure TFrmTXDetails.btnEditClick(Sender: TObject);
begin
  if bgCommsWorking then ChangeFormMode(fmEdit)
  else TillCommsError;
end;

procedure TFrmTXDetails.btnAddClick(Sender: TObject);
begin
  if bgCommsWorking then
    begin
      TXType := ttPaidIn;
      UpdateDetails(ExLocal,fmAdd);
    end
  else TillCommsError;
end;

function TFrmTXDetails.SaveTXDetails : boolean;
begin
  Screen.Cursor := crHourglass;
  with ExLocal,LInv do begin
    if FrmComms.Till_OnLine(0) then
      begin
        if (Syss.VatMode = vmAdv) then InvVAT := Calc_IncVAT({Inv.}InvNetVal);
        case FormMode of
          fmAdd : begin
            LResetRec(InvF);
            Form2Inv;
            PrevBal := LCust.CurrBalance;
            SetNextDocNos(LInv,TRUE);
            Result := TRUE;
          end;

          fmEdit : begin
            Form2Inv;
            Result := UpdateBal(ExLocal,1);
          end;
        end;{case}

        if Result and UpdateBal(ExLocal,0) then
          begin
            case FormMode of
              fmAdd : AddRecord(InvF, ExLocal);
              fmEdit : SaveRecord(InvF, ExLocal);
            end;{case}

            {$IFDEF Ex_On}
{              if (Syss.VatMode = vmAdv) then OExchequer.Control_SR(LInv,(FormMode = fmEdit),1, 0)  {* Add NTxFR *}
{              else OExchequer.Control_NT(LInv,(FormMode = fmEdit), 0);  {* Add NTxFR *}
            {$ENDIF}
          end
        else begin
          MsgBox('One or more tills did not accept the new balance, so this receipt has not been added.',mtWarning,[mbOK],mbOK,'Add Receipt');
          Result := FALSE;
        end;{if}
      end
    else begin
      Result := FALSE;
      TillCommsError;
    end;{if}
  end;{with}
  Screen.Cursor := crDefault;
end;

procedure TFrmTXDetails.Form2Inv;
begin
  with ExLocal, LInv do begin
    if FormMode = fmAdd then begin
      CustCode := LCust.CustCode;
      if (Syss.VatMode = vmAdv) then InvDocHed := SRI
      else InvDocHed := NMT;

      TransDate := edDate.DateValue;
      lRefNo.Caption := OurRef;

      {Work out paytype from combo}
      Case cmbPaytype.ItemIndex of
        0 : Paytype := 'A';
        1 : Paytype := 'R';
        2 : Paytype := 'C';
        3 : Paytype := 'F';
      end;{case}
    end;{if}

    InvNetVal := edReceived.Value;
    Discount := edIncentive.Value;
    DiscAmount := ((StrToPence(lEQValue.Caption) -  PenceIt(edReceived.Value)) / 100) * -1;
    TransDesc := edComments.Text; {comments}
  end;{with}
end;

procedure TFrmTXDetails.Inv2Form;
begin
  with ExLocal, LInv do begin
    edDate.DateValue := TransDate;
    lRefNo.Caption := OurRef;
    Case PayType of
      'A' : cmbPaytype.ItemIndex := 0;{Cash}
      'R' : cmbPaytype.ItemIndex := 1;{Renewal}
      'C' : cmbPaytype.ItemIndex := 2;{Correction}
      'F' : cmbPaytype.ItemIndex := 3;{Forfeit}
    else cmbPaytype.ItemIndex := -1;
    end;{case}
    edReceived.Value := InvNetVal;
    edIncentive.Value := Discount;
    lEQValue.Caption := PenceToStr(PenceIt(InvNetVal - DiscAmount));

    if TXType = ttPaidIn then lTotDiscount.Caption := PenceToStr(PenceIt(DiscAmount) * -1);
    edComments.Text := TransDesc; {comments}
  end;{with}
end;

procedure TFrmTXDetails.edIncentiveEnter(Sender: TObject);
begin
  rPrevRate := edIncentive.Value;
end;

end.


