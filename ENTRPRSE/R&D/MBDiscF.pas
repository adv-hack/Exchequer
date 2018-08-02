unit MBDiscF;

interface


uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, BorBtns, TEditVal, Mask, StdCtrls, bkgroup, MultiBuyVar, VarConst,
  EnterToTab{$IFDEF SOP}, MultiBuyFuncs{$ENDIF};

const

  dmAdd    = 0;
  dmEdit   = 1;
  dmDelete = 2;

type
  TfrmMBDDetails = class(TForm)
    lblStockCode: Label8;
    Label811: Label8;
    Label814: Label8;
    Label815: Label8;
    lblReward: Label8;
    lblStockDesc: Label8;
    btnOK: TButton;
    btnCancel: TButton;
    cbCurrency: TSBSComboBox;
    ceBuyQty: TCurrencyEdit;
    ceRewardValue: TCurrencyEdit;
    edtStockCode: Text8Pt;
    edtStockDesc: Text8Pt;
    deStartDate: TEditDate;
    deEndDate: TEditDate;
    chkUseDates: TBorCheckEx;
    cbType: TComboBox;
    EnterToTab1: TEnterToTab;
    procedure FormCreate(Sender: TObject);
    procedure cbTypeChange(Sender: TObject);
    procedure edtStockCodeExit(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure chkUseDatesClick(Sender: TObject);
  private
    { Private declarations }
    LStockRec : StockRec;
    {$IFDEF SOP}
    FMBDFunctions : TMultiBuyFunctions;
    {$ENDIF}
    FIsStock: Boolean;
    FMBDRec : TMultiBuyDiscount;
    function GetStockRec : Boolean;
    procedure SetIsStock(const Value: Boolean);
    function ValidateDiscount : Boolean;
    procedure SetDecimalPlaces;
  public
    { Public declarations }
    WantDelete, DoDelete : Boolean;
    FirstTime : Boolean;
    DispMode : Byte;
    procedure RecordToForm(const MBDRec : TMultiBuyDiscount; NewRec : Boolean = False);
    procedure FormToRecord(var MBDRec : TMultiBuyDiscount);
    procedure SetControls;
    property IsStock : Boolean read FIsStock write SetIsStock;
  end;

var
  frmMBDDetails: TfrmMBDDetails;

implementation

uses
  BtKeys1U, BtSupU1, BtSupU2, InvListU, GlobVar, ApiUtil, EtMiscU, ThemeFix,
  AuditNotes, BtrvU2;

{$R *.dfm}

{ TfrmMBDDetails }

procedure TfrmMBDDetails.FormToRecord(var MBDRec: TMultiBuyDiscount);
begin
{$IFDEF SOP}
  if IsStock then
  begin
    MBDRec.mbdOwnerType := mboStock;
    MBDRec.mbdAcCode := FullCustCode('');
  end
  else
  begin
    MBDRec.mbdOwnerType := Cust.CustSupp;
    MBDRec.mbdAcCode := FullCustcode(Cust.CustCode);
  end;
  MBDRec.mbdStockCode := FullStockCode(edtStockCode.Text);
  MBDRec.mbdDiscountType := IntToStr(cbType.ItemIndex)[1];
  MBDRec.mbdBuyQty := ceBuyQty.Value;
  MBDRec.mbdBuyQtyString := FormatBuyQtyString(MBDRec.mbdBuyQty);
  {$IFDEF MC_ON}
  MBDRec.mbdCurrency := cbCurrency.ItemIndex;
  {$ELSE}
  MBDRec.mbdCurrency := 0;
  {$ENDIF}
  if MBDRec.mbdDiscountType = mbtGetPercentOff then
    MBDRec.mbdRewardValue := Round_Up(ceRewardValue.Value / 100, 4)
  else
    MBDRec.mbdRewardValue := ceRewardValue.Value;
  MBDRec.mbdUseDates := chkUseDates.Checked;
  MBDRec.mbdStartDate := deStartDate.DateValue;
  MBDRec.mbdEndDate := deEndDate.DateValue;
{$ENDIF}
end;

function TfrmMBDDetails.GetStockRec: Boolean;
var
  TempStock : StockRec;
begin
  TempStock := Stock;
  Result := CheckRecExsists(FullStockCode(edtStockCode.Text), StockF, StkCodeK);
  LStockRec := Stock;
  Stock := TempStock;
end;

procedure TfrmMBDDetails.RecordToForm(const MBDRec: TMultiBuyDiscount; NewRec : Boolean = False);
begin
{$IFDEF SOP}
  FMBDRec := MBDRec;
  if IsStock and NewRec then
  begin
    edtStockCode.Text := Trim(Stock.StockCode);
    edtStockDesc.Text := Trim(Stock.Desc[1]);
  end
  else
  begin
    edtStockCode.Text := Trim(MBDRec.mbdStockCode);
    if GetStockRec then
      edtStockDesc.Text := Trim(LStockRec.Desc[1]);
  end;
  cbType.ItemIndex := Ord(MBDRec.mbdDiscountType) - Ord(mbtGetFree);
  cbTypeChange(cbType);
  ceBuyQty.Value := MBDRec.mbdBuyQty;
  {$IFDEF MC_ON}
  if MBDRec.mbdCurrency < cbCurrency.Items.Count then
    cbCurrency.ItemIndex := MBDRec.mbdCurrency
  else
  {$ENDIF}
    cbCurrency.ItemIndex := 0;
  if MBDRec.mbdDiscountType = mbtGetPercentOff then
     ceRewardValue.Value := MBDRec.mbdRewardValue * 100
  else
     ceRewardValue.Value := MBDRec.mbdRewardValue;
  chkUseDates.Checked := MBDRec.mbdUseDates;
  deStartDate.DateValue := MBDRec.mbdStartDate;
  deEndDate.DateValue := MBDRec.mbdEndDate;
{$ENDIF}
end;

procedure TfrmMBDDetails.FormCreate(Sender: TObject);
var
  ListPoint : TPoint;
begin
  // MH 12/01/2011 v6.6 ABSEXCH-10548: Modified theming to fix problem with drop-down lists
  ApplyThemeFix (Self);

{$IFDEF SOP}
  FMBDFunctions := TMultiBuyFunctions.Create;
  FirstTime := True;
  DoDelete := False;
  With TWinControl(Owner) do
  Begin
    ListPoint.X:=Width - Self.Width - 8;
    ListPoint.Y:=Height - Self.Height - 8;

    ListPoint:=ClientToScreen(ListPoint);
  end;
  Left := ListPoint.X;
  Top := ListPoint.Y;
  DispMode := 0;
{$IFDEF MC_ON}
  Set_DefaultCurr(cbCurrency.Items,True,False);
  Set_DefaultCurr(cbCurrency.ItemsL,True,True);
  cbCurrency.ItemIndex := 0;
{$ELSE}
  cbCurrency.Visible := False;
{$ENDIF}
{$ENDIF SOP}
end;

procedure TfrmMBDDetails.cbTypeChange(Sender: TObject);
begin
  lblReward.Caption := RewardValueName[cbType.ItemIndex];
  {$IFDEF MC_ON}    //PR: 09/07/2009 Keep currency list invisible in SC version
  cbCurrency.Visible := cbType.ItemIndex = 1;
  {$ENDIF}
  if cbCurrency.Visible then
  begin
    ceRewardValue.Left := cbCurrency.Left + cbCurrency.Width + 4;
//    ceRewardValue.Width := 99;
  end
  else
  begin
    ceRewardValue.Left := cbCurrency.Left;
//    ceRewardValue.Width := cbType.Width;
  end;
  SetDecimalPlaces;
end;

procedure TfrmMBDDetails.edtStockCodeExit(Sender: TObject);
var
  FoundOK : Boolean;
  FoundCode : Str20;
  StkFolio : longint;
begin
{$IFDEF SOP}
  if (ActiveControl <> btnCancel) and not FIsStock then  //PR: 18/08/2009 Added check for IsStock
  begin
    FoundCode := Trim(edtStockCode.Text);
    //PR: 16/06/2009 Change call to disallow groups
    FoundOk:=(GetsdbStock(Self,FoundCode,MultiBuyDiscount.mbdAcCode,FoundCode,StkFolio,0));
    if FoundOK then
    begin
      edtStockCode.Text := FoundCode;

     if GetStockRec then
       edtStockDesc.Text := Trim(LStockRec.Desc[1]);
    end
    else
      ActiveControl := edtStockCode;
  end;
{$ENDIF}
end;

procedure TfrmMBDDetails.FormActivate(Sender: TObject);
var
  Res : Integer;
begin
  if WantDelete and FirstTime then
  begin
    FirstTime := False;
    Res := msgBox('Please confirm you wish to delete this Discount Record.', mtConfirmation, [mbYes, mbNo], mbNo, 'Confirm');
    if Res = mrYes then
    begin
      //TW 07/11/2011 Adds MBD Delete audit note.
      TAuditNote.WriteAuditNote(anAccount, anEdit);

      ModalResult := mrOK;
      DoDelete := True;
      PostMessage(Self.Handle, WM_CLOSE, 0, 0);
    end
    else
      btnOK.Enabled := False;
  end;

end;

procedure TfrmMBDDetails.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if ModalResult = mrOK then
  begin
    // Move focus to OK button to force OnExit validation/formatting to kick in
    If btnOk.CanFocus Then
      btnOk.SetFocus;
    // If focus isn't on the OK button then that implies a validation error so the store should be abandoned
    If (ActiveControl = btnOk) Then
    begin
      CanClose := ValidateDiscount;
      // CA  06/06/2012   v7.0  ABSEXCH-12762: - Multi-buy Discount End date cannot be earlier than start date
      if (chkUseDates.Checked) And (deEndDate.DateValue < deStartDate.DateValue) Then
      begin
         msgBox('Effective End Date must not be earlier than the Effective Start Date', mtWarning, [mbOK], mbOK, 'Invalid Value');
         CanClose := False;
      end;
      if ceBuyQty.Value < 0.000001 then
      begin
         msgBox('Buy Quantity must be more than zero', mtWarning, [mbOK], mbOK, 'Invalid Value');
        CanClose := False;
      end;
      if ceRewardValue.Value < 0.000001 then
      begin
         msgBox(RewardValueName[cbType.ItemIndex] + ' must be more than zero', mtWarning, [mbOK], mbOK, 'Invalid Value');
         CanClose := False;
      end;
    end
    else
      CanClose := False;

    //TW 07/11/2011 Adds MBD save audit note.
    if(canClose) then
      TAuditNote.WriteAuditNote(anAccount, anEdit );
  end;
end;

procedure TfrmMBDDetails.FormDestroy(Sender: TObject);
begin
{$IFDEF SOP}
  FMBDFunctions.Free;
{$ENDIF}
end;

procedure TfrmMBDDetails.chkUseDatesClick(Sender: TObject);
begin
  deStartDate.TabStop := chkUseDates.Checked;
  deEndDate.TabStop := chkUseDates.Checked;
end;

procedure TfrmMBDDetails.SetControls;
begin
  if FIsStock then
  begin
    edtStockCode.ReadOnly := True;
    edtStockCode.TabStop := False;
    edtStockCode.Color := clBtnFace;
    ActiveControl := cbType;
  end
  else
    ActiveControl := edtStockCode;
end;

procedure TfrmMBDDetails.SetIsStock(const Value: Boolean);
begin
  FIsStock := Value;
  SetControls;
end;

function TfrmMBDDetails.ValidateDiscount: Boolean;
var
  MBDRec : TMultiBuyDiscount;
  Res : Integer;
  Msg : string;
begin
  Result := False;
{$IFDEF SOP}
  FormToRecord(MBDRec);
  Result := True;
  //PR: 17/06/2009 Add check for Reward Value > BuyQty
  if MBDRec.mbdDiscountType = mbtGetFree then
  begin
    Result := MBDRec.mbdRewardValue <= MBDRec.mbdBuyQty;
    if not Result then
      msgBox('Free Quantity can not be greater than Buy Quantity.', mtWarning, [mbOK], mbOK, 'Store Multi-Buy Discount');
  end;

  //PR: 07/07/2009 FR v6.01.119
  if Result then
  begin
    Res := FMBDFunctions.ValidateDiscount(MBDRec, DispMode = dmEdit);
    Result := Res = 0;
    if not Result then
    begin //Show error message
      Msg := 'You can not have two Multi-Buy Discounts';
      if (Res and rcType) = rcType then
        Msg := Msg + ' of different types'
      else
      if (Res and rcQty) = rcQty then
        Msg := Msg + ' with the same Buy Quantity';

  //    if (Res and rcDate) = rcDate then
        Msg := Msg + ' within the same Date Range';

      if (Res and rcCurrency) = rcCurrency then
      begin
        if IsStock then
          Msg := Msg + ' for the same Currency and Stock Code'
        else
          Msg := Msg + ' for the same Currency, Account Code and Stock Code';
      end
      else
      if not IsStock then
        Msg := Msg + ' for the same Account Code and Stock Code'
      else
        Msg := Msg + ' for the same Stock Code';

      Msg := Msg + '.';

      msgBox(Msg, mtWarning, [mbOK], mbOK, 'Store Multi-Buy Discount');

      ActiveControl := cbType;
    end;
end;
{$ENDIF}
end;

procedure TfrmMBDDetails.SetDecimalPlaces;
begin
  ceBuyQty.DecPlaces := Syss.NoQtyDec;
  Case Char(cbType.ItemIndex + 48) of
     mbtGetFree       : ceRewardValue.DecPlaces := Syss.NoQtyDec;
     mbtForAmount     : if FMBDRec.mbdOwnerType in ['C', 'T'] then
                          ceRewardValue.DecPlaces := Syss.NoNetDec
                        else
                          ceRewardValue.DecPlaces := Syss.NoCosDec;
     mbtGetPercentOff : ceRewardValue.DecPlaces := 2;

  end; //Case
end;

end.















