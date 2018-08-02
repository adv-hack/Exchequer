unit CLPAlMCU;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, TEditVal, ExtCtrls, SBSPanel, bkgroup, BorBtns,
  VarConst;

type
  TCLPAMCl = class(TForm)
    OkCP1Btn: TButton;
    CanCP1Btn: TButton;
    UseLocalCB: TCheckBox;
    lblCurr: TLabel;
    panPPD: TPanel;
    PALab: Label8;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lblOSVal: TLabel;
    lblOSValCurr: TLabel;
    lblPPD: TLabel;
    lblPPDCurr: TLabel;
    lblPayReq: TLabel;
    lblPayReqCurr: TLabel;
    PAMntF: TCurrencyEdit;
    PAMCAmntF: TCurrencyEdit;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure PAMntFExit(Sender: TObject);
    procedure PAMCAmntFExit(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure OkCP1BtnClick(Sender: TObject);
    procedure UseLocalCBClick(Sender: TObject);
    private
      InPAmntExit,
      PrevHState  :  Boolean;

      Procedure SetMCColor;


      Procedure OutIS;

      Procedure Form2IS;

      //PR: 15/07/2015 ABSEXCH-16660 Function to check for PPD on manual allocation and display warning to user
      function ContinueManualPartAllocation : Boolean;

    public
      { Public declarations }
      PAValue,
      MCValue    : Double;
      BSDiscMode,
      BudgetMode,
      JCChargeMode,
      PDayRateFlg        {*EL v6.01 Force behavior of part allocation to use Invoice exchange rate if hook 2000,200 present. Defaults to UseCoDayRate
                               Not set by manual allocation routines, so hook only valid for Allocation wizard*}
                 : Boolean;

      LocalInv   : InvRec;

      BCurSymb   : String[5];

      //PR: 14/05/2015 ABSEXCH-16284
      FOsValue : Double;
      FPPDAvailable : Double;
      FPPDAvailableBase : Double;
      TakeThePPD : Boolean;

      Function InitIS(VO    :  Boolean;
                      Col1  :  TColor;
                      Fon1  :  TFont):  Word;

      //PR: 14/05/2015 ABSEXCH-16284 procedures to deal with presence or absence of PPD
      procedure SetToDefault;
      procedure SetPPDValues(OSVal : Double; PPDAvailable : Double);
      procedure PopulatePPDValues;
  end;


{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Uses
  ETStrU,
  ETMiscU,
  GlobVar,

  SBSComp2,
  CurrncyU,
  BTSupU1,
  BTSupU2,
  ApiUtil,

  Saltxl1U,
  PromptPaymentDiscountFuncs,
  ComnUnit;

{$R *.DFM}



{ ==== Procedure to Display Address ==== }

Procedure TCLPAMCl.OutIS;


Begin
  PAmntF.Value:=PAValue;

  UseLocalCB.Visible:=(LocalInv.Currency>1);

  lblCurr.Visible := UseLocalCB.Visible;
  PAMCAMntF.Visible:=UseLocalCB.Visible;

  //PR: 14/05/2015 ABSEXCH-16284 Hide PPD Fields
  lblOSValCurr.Visible  := UseLocalCB.Visible;
  lblPPDCurr.Visible    := UseLocalCB.Visible;
  lblPayReqCurr.Visible := UseLocalCB.Visible;


  If (UseLocalCB.Visible) then
    PAMntFExit(nil)
  else
  begin
    ClientHeight := 100;
    OKCP1Btn.Top := 65;
    CanCP1Btn.Top := OKCP1Btn.Top;

    OKCP1Btn.Left := 140;
    CanCP1Btn.Left := 223;

    panPPD.Left := 8;
    panPPD.Height := PAMntF.Top + 25;
    ClientWidth := 436;
  end;
end;



Procedure TCLPAMCl.Form2IS;

Begin
  PAValue:=PAmntF.Value;

  If (UseLocalCB.Visible) then
    MCValue:=PAMCAmntF.Value
  else
    MCValue:=PAValue;

end;

Procedure TCLPAMCl.SetMCColor;
Begin
  If (Not PAMCAmntF.ReadOnly) then
  Begin
    With PAMCAmntF do
    Begin
      Color:=PAmntF.Color;
      Font.Assign(PAmntF.Font);
    end;

  end
  else
  With PAMCAmntF do
  Begin
    Color:=clBtnFace;
    Font.Color:=clBlack;
  end;

end;

Function TCLPAMCl.InitIS(VO    :  Boolean;
                       Col1  :  TColor;
                       Fon1  :  TFont):  Word;


Begin
  With PAmntF do
  Begin
    Color:=Col1;
    Font.Assign(Fon1);
  end;

  If (BSDiscMode) then
  Begin
    Caption:='Additional Discount';
    PALab.Caption:='Settlement Discount in '+BCurSymb;
    Self.HelpContext:=1167;
  end
  else
  If (Not BudgetMode) then
  Begin
    {$IFDEF MC_On}
      PALab.Caption:='How Much?';

      If (Not JCChargeMode) then
      Begin
        PALab.Caption:=PALab.Caption+' in '+Ssymb(0);
        lblCurr.Caption:=Ssymb(LocalInv.Currency);
      end;
    {$ENDIF}
  end;

  OutIS;

  if (FPPDAvailable <> 0.00) and ( Round_Up(PAValue, 2) >= Round_Up(Abs(FOSValue) - FPPDAvailable, 2)) then
    PopulatePPDValues
  else
    SetToDefault;

  SetAllowHotKey(BOff,PrevHState);

  Result:=ShowModal;

  SetAllowHotKey(BOn,PrevHState);

  If (Result=mrOk) then
  Begin
    LastValueObj.UpdateAllLastValues(Self);

    Form2IS;
  end;
end;



procedure TCLPAMCl.FormKeyPress(Sender: TObject; var Key: Char);
begin
  GlobFormKeyPress(Sender,Key,ActiveControl,Handle);
end;

procedure TCLPAMCl.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GlobFormKeyDown(Sender,Key,Shift,ActiveControl,Handle);
end;


procedure TCLPAMCl.FormCreate(Sender: TObject);
begin
  ClientHeight:=123;
  ClientWidth:=496;
  BSDiscMode:=BOff;
  BudgetMode:=BOff;
  InPAmntExit:=BOff;
  PDayRateFlg:=UseCoDayRate;

  FOSValue := 0.00;
  FPPDAvailable := 0.00;
  TakeThePPD := False;
end;

procedure TCLPAMCl.PAMntFExit(Sender: TObject);
Var
  UOR  :  Byte;

begin
  If (Not InPAmntExit) then
  Begin
    InPAmntExit:=BOn;

    If (Not PAmntF.Modified) and (Round_Up(PAmntF.Value,2)=Round_Up(PAValue,2)) then
      PAmntF.Value:=PAValue;

    {$IFDEF MC_ON}
    If (PAMCAmntF.Visible) then
    With LocalInv do
    Begin
      UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

      PAMCAmntF.Value:=Round_Up(Conv_TCurr(PAmntF.Value,XRate(CXRate,PDayRateFlg,Currency),Currency,UOR,BOn),2);

    end;
    {$ENDIF}
    InPAmntExit:=BOff;
  end;
end;

procedure TCLPAMCl.PAMCAmntFExit(Sender: TObject);
Var
  UOR  :  Byte;

begin
  {$IFDEF MC_ON}
  If (UseLocalCB.Checked) and (Not PAMCAmntF.ReadOnly) then
  With LocalInv do
  Begin
    UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

    PAmntF.Value:=Round_Up(Conv_TCurr(PAMCAmntF.Value,XRate(CXRate,PDayRateFlg{BOff},Currency),Currency,UOR,BOff),2);

  end;
  {$ENDIF}
end;

procedure TCLPAMCl.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  AllocValue : Double;
  ValueIncPPD : Double;
  ValueIncPPDCurrency : Double;
  PPDAvailableCurrency : Double;
  PPDCheckResult : Integer;
begin
  //PR: 20/01/2009 2003422142821 If the amount to be allocated is greater then the amount o/s on the Inv, ask user to confirm.
  if ModalResult = mrOK then
  begin
    if Round_Up(PAmntF.Value, 2) > Round_Up(PAValue, 2) then
      CanClose := msgBox(Format('Warning: This amount will over-allocate the %s. Are you sure you wish to continue?', [DocNames[LocalInv.InvDocHed]]),
                         mtWarning, [mbYes, mbNo], mbNo, Application.Title) = mrYes
    else
    if FPPDAvailable <> 0.0 then
    begin
      AllocValue := Round_Up(PAmntF.Value, 2);
      ValueIncPPD := Round_Up(FOSValue - FPPDAvailable, 2);

      PPDAvailableCurrency := Round_Up(LocalInv.thPPDGoodsValue + LocalInv.thPPDVATValue, 2);
      ValueincPPDCurrency := Round_Up(ITotal(LocalInv) - PPDAvailableCurrency, 2);

      if AllocValue = ValueIncPPD then
      begin   //PR: 14/05/2015 ABSEXCH-16284 if allocation = (o/s - PPD) then ask the user if thwy want to take PPD
        PPDCheckResult := msgBox(Format('Do you wish to %s %s PPD?',
                                                  [PPDGiveTakeWord(Cust.CustSupp, False),
                                                   Trim(FormatCurFloat(GenRealMask,PPDAvailableCurrency, BOff, LocalInv.Currency))]),
                                          mtConfirmation, mbYesNoCancel, mbYes, 'Part Allocation');
        if PPDCheckResult = mrYes then
          TakeThePPD := True
        else
        if PPDCheckResult = mrCancel then
          CanClose := False;
      end
      else
      if (AllocValue > ValueIncPPD)then
      begin  //PR: 14/05/2015 ABSEXCH-16284 Check for allocating more than o/s - PPD
        // CJS 2015-07-01 - ABSEXCH-16586 - Message on Part Allocate button
        PPDCheckResult := msgBox(Format('If you allocate %s you have %s PPD available. Do you wish to take PPD?',
                           [Trim(FormatCurFloat(GenRealMask,ValueIncPPDCurrency,BOff,LocalInv.Currency)),
                            Trim(FormatCurFloat(GenRealMask,PPDAvailableCurrency,BOff,LocalInv.Currency))]),
                            mtWarning, mbYesNoCancel, mbYes, Application.Title);

        if PPDCheckResult = mrYes then
        begin
          //Set the value to be (o/s - PPD)
          PAmntF.Value := ValueIncPPD;

          //Update currency value
          PAMntFExit(PAMntF);

          TakeThePPD := True;
        end
        else
        if PPDCheckResult = mrCancel then  //Back to form
          CanClose := False;
      end;

    end;
  end;
end;

procedure TCLPAMCl.OkCP1BtnClick(Sender: TObject);
begin
  // MH 15/12/2010 v6.6 ABSEXCH-10548: Set focus to OK button to trigger OnExit event on TCurrencyEdit which
  //                                   processes the text and updates the value
  OkCP1Btn.SetFocus;

  //PR: 15/07/2015 ABSEXCH-16660 If manual part allocation check for PPD and user's response
  if not ContinueManualPartAllocation then
    Self.ModalResult := mrCancel;
end;

//Resize the form to it's non-PPD size
procedure TCLPAMCl.SetToDefault;
var
  OffSet : Integer;
begin
  //Hide ppd labels

  //Reset to dimensions without PPD
  ClientWidth  := panPPD.Left + 167;
  panPPD.Width := 127;

  if not PAMCAmntF.Visible then
  begin
    panPPD.Left := 26;
    OffSet := 0;
  end
  else
    OffSet := 25;

  OKCP1Btn.Left  := 8 + Offset;
  CanCP1Btn.Left := 91 + Offset;

  lblOSVal.Visible := False;
  lblOsValCurr.Visible := False;

end;

//Does what it says on the tin
procedure TCLPAMCl.PopulatePPDValues;
var
  dTemp : Double;
  UOR : Byte;

  function DoFormat(Value : Double; Currency : Integer) : string;
  begin
    Result := Trim(FormatCurFloat(GenRealMask,Value,BOff,Currency));
  end;

begin

  //Set base values
  lblOSVal.Caption := DoFormat(FOSValue,0);
  lblPPD.Caption := DoFormat(FPPDAvailable,0);
  lblPayReq.Caption := DoFormat(Round_Up(FOSValue - FPPDAvailable, 2),0);

  {$IFDEF MC_ON}
  if PAMCAmntF.Visible then //Set currency values - currency of invoice, not currency of allocation
  With LocalInv do
  begin
    UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);

    dTemp := Round_Up(Conv_TCurr(FOSValue,XRate(CXRate,PDayRateFlg,Currency),Currency,UOR,BOn),2);
    lblOSValCurr.Caption := DoFormat(dTemp,Currency);

    dTemp := Round_Up(Conv_TCurr(FPPDAvailable,XRate(CXRate,PDayRateFlg,Currency),Currency,UOR,BOn),2);
    lblPPDCurr.Caption := DoFormat(dTemp,Currency);

    dTemp := Round_Up(Conv_TCurr(FOSValue - FPPDAvailable,XRate(CXRate,PDayRateFlg,Currency),Currency,UOR,BOn),2);
    lblPayReqCurr.Caption := DoFormat(dTemp,Currency);

  end;
  {$ENDIF}
end;

procedure TCLPAMCl.UseLocalCBClick(Sender: TObject);
begin
  PAMCAmntF.ReadOnly:=Not UseLocalCB.Checked;

  PAMCAmntF.TabStop:=UseLocalCB.Checked;

  SetMCColor;
end;

procedure TCLPAMCl.SetPPDValues(OSVal, PPDAvailable: Double);
begin
  //Store values in local variables for later use
  FOSValue := OSVal;
  FPPDAvailable := PPDAvailable;
end;

//PR: 15/07/2015 ABSEXCH-16660 Function to check for PPD on manual allocation and display warning to user
function TCLPAMCl.ContinueManualPartAllocation: Boolean;
var
  PPDAvailableCurrency : Double;
  ValueLessPPDCurrency : Double;
  AllocationValue : Double;
begin
  //FPPDAvailable is set by wizard so will be 0 for manual
  Result := FPPDAvailable <> 0.00;

  if not Result then
  begin
    //Calculate total less PPD in currency
    PPDAvailableCurrency := Round_Up(LocalInv.thPPDGoodsValue + LocalInv.thPPDVATValue, 2);
    ValueLessPPDCurrency := Round_Up(Abs(CurrencyOS(LocalInv, True, False, False)) - PPDAvailableCurrency, 2);

    {$IFDEF MC_ON}
      //If transaction is in currency then take value from PAMCAmntF
      //If transaction is in base then take from PAMntF
     if LocalInv.Currency > 1 then
       AllocationValue := Round_Up(PAMCAmntF.Value, 2)
     else
       AllocationValue := Round_Up(PAMntF.Value, 2);
    {$ELSE}
     AllocationValue := Round_Up(PAMntF.Value, 2);
    {$ENDIF}

    //If nothing o/s except for PPD, then allow allocation to go through
    if (ValueLessPPDCurrency = PPDAvailableCurrency) and (AllocationValue = ValueLessPPDCurrency) then
      Result := True
    else
    if AllocationValue > ValueLessPPDCurrency then
      Result := ContinueWithManualAllocation(LocalInv)
    else
    begin
      {SS 14/03/2016 2016-R2
       ABSEXCH-17048:PPD Available message popping up when part allocating for Traders where PPD Disabled.
       Added a condition to check weather PPD mode is disabled or not for the Customer/Supplier.}

      if not (LocalInv.InvDocHed in [SRC, PPY]) and (AllocationValue = ValueLessPPDCurrency) and (Cust.acPPDMode <> pmPPDDisabled) then
      begin
        //PR: 04/08/2015 ABSEXCH-16660 Changed text again as per AP's wishes

        Result := msgBox('This transaction has PPD available.'#10#10'The amount entered matches the invoice less the PPD value; ' +
         'if you continue, please create a separate credit for the PPD value.'#10#10 +
         'Are you sure you want to allocate?', mtConfirmation,
               [mbYes, mbNo], mbNo, 'PPD Available') = mrYes;
      end
      else
        Result := True;
    end;

  end;
end;

end.
