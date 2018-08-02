unit TTDF;

{$If not (Defined(SOP) or Defined(COMTK))}
  This unit should not be compiling into this application/dll
{$IfEnd}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, TEditVal, BorBtns, ExtCtrls, GlobVar, VarConst,
  EnterToTab, Contnrs, Math
{$IFDEF TRADE}
  , TTDCalcTCM;
{$ELSE}
  , TTDCalc, VBD;
{$ENDIF}

type
  TfrmTTDOffer = class(TForm)
    lblTotalCost: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    edtAfterNetTotal: TCurrencyEdit;
    Label2: TLabel;
    edtAfterNetLessSettle: TCurrencyEdit;
    edtAfterTotalCost: TCurrencyEdit;
    edtBeforeNetTotal: TCurrencyEdit;
    lblNetLessSettle: TLabel;
    edtBeforeNetLessSettle: TCurrencyEdit;
    edtBeforeTotalCost: TCurrencyEdit;
    EnterToTab1: TEnterToTab;
    panVBDNotifcation: TPanel;
    Bevel1: TBevel;
    lblVBDOffer: TLabel;
    panTTDOffer: TPanel;
    Label6: TLabel;
    Label7: TLabel;
    Bevel2: TBevel;
    btnApplyTTD: TButton;
    btnCancel: TButton;
    radNoTTD: TBorRadio;
    radPercentageTTD: TBorRadio;
    radValueTTD: TBorRadio;
    edtTTDPercentage: TCurrencyEdit;
    edtTTDValue: TCurrencyEdit;
    lblDiscountApplied: TLabel;
    edtDiscountApplied: TCurrencyEdit;
    tmBlinky: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure btnApplyTTDClick(Sender: TObject);
    procedure DoClickyClicky(Sender: TObject);
    procedure edtTTDPercentageChange(Sender: TObject);
    procedure edtTTDValueChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure edtTTDPercentageKeyPress(Sender: TObject; var Key: Char);
    procedure tmBlinkyTimer(Sender: TObject);
    procedure edtTTDValueKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    FValidationError : Boolean;
    FVBDChecked : Boolean;
    FTTDCalculator : TTTDCalculator;
  {$IFNDEF TRADE}
    FVBDList : TVBDList;
  {$ENDIF}
    Procedure SetSampleControl (SampleControl : Text8pt);
    Procedure SetTTDCalculator (Value : TTTDCalculator);

    Procedure SetValidationError (Value : Boolean);
    Procedure UpdateTotals;

    function RemoveBadChars(BadString : ShortString) : ShortString;
  public
    { Public declarations }
    Property ValidationError : Boolean Read FValidationError Write SetValidationError;
    Property SampleControl : Text8pt Write SetSampleControl;
    Property TTDCalculator : TTTDCalculator Read FTTDCalculator Write SetTTDCalculator;
  {$IFNDEF TRADE}
    Property VBDList : TVBDList Read FVBDList Write FVBDList;
  {$ENDIF}
  end;

{$IFDEF TRADE}
  Function OfferTTD (Const Owner : TComponent; Const SampleControl : Text8Pt; Const oTTDCalculator : TTTDCalculator) : Boolean;
{$ELSE}
  Function OfferTTD (Const Owner : TComponent; Const SampleControl : Text8Pt; Const oTTDCalculator : TTTDCalculator; Const oVBDList : TVBDList) : Boolean;
{$ENDIF}


implementation

{$R *.dfm}

Uses ETMiscU;

//=========================================================================

{$IFDEF TRADE}
Function OfferTTD (Const Owner : TComponent; Const SampleControl : Text8Pt; Const oTTDCalculator : TTTDCalculator) : Boolean;
Var
  frmTTDOffer : TfrmTTDOffer;
Begin // OfferTTD
  frmTTDOffer := TfrmTTDOffer.Create(Owner);
  Try
//    frmTTDOffer.VBDList := oVBDList;   // Must be done first
    frmTTDOffer.TTDCalculator := oTTDCalculator;
    frmTTDOffer.SampleControl := SampleControl;

    Result := (frmTTDOffer.ShowModal = mrOK);
  Finally
    frmTTDOffer.Free;
  End; // Try..Finally
End; // OfferTTD
{$ELSE}
Function OfferTTD (Const Owner : TComponent; Const SampleControl : Text8Pt; Const oTTDCalculator : TTTDCalculator; Const oVBDList : TVBDList) : Boolean;
Var
  frmTTDOffer : TfrmTTDOffer;
Begin // OfferTTD
  frmTTDOffer := TfrmTTDOffer.Create(Owner);
  Try
    frmTTDOffer.VBDList := oVBDList;   // Must be done first
    frmTTDOffer.TTDCalculator := oTTDCalculator;
    frmTTDOffer.SampleControl := SampleControl;

    Result := (frmTTDOffer.ShowModal = mrOK);
  Finally
    frmTTDOffer.Free;
  End; // Try..Finally
End; // OfferTTD
{$ENDIF}

//=========================================================================

procedure TfrmTTDOffer.FormCreate(Sender: TObject);
Var
  P : TPoint;
begin
  // Position form centrally over the own transaction window
  With TForm(Owner) Do
    P := ClientToScreen(Point(ClientWidth Div 2, ClientHeight Div 2));
  Top := P.Y - (Height Div 2);
  Left := P.X - (Width Div 2);

  FVBDChecked := False;
end;

//-------------------------------------------------------------------------

procedure TfrmTTDOffer.FormActivate(Sender: TObject);
begin
  If (Not FVBDChecked) Then
  Begin
    FVBDChecked := True;

    If FTTDCalculator.VBDExists Then
    Begin
      MessageDlg ('A Value Based Discount is already present on this transaction, if you apply a ' +
                  'Transaction Total Discount then the Value Based Discount will be removed.  To ' +
                  'store the transaction leaving the Value Based Discount intact click the Cancel ' +
                  'button.', mtWarning, [mbOK], 0);
    End; // If FTTDCalculator.VBDExists
  End; // If (Not FVBDChecked)
end;

//-------------------------------------------------------------------------

procedure TfrmTTDOffer.tmBlinkyTimer(Sender: TObject);
begin
  If (edtDiscountApplied.Font.Color = edtBeforeNetTotal.Font.Color) Then
    edtDiscountApplied.Font.Color := edtDiscountApplied.Color
  Else
    edtDiscountApplied.Font.Color := edtBeforeNetTotal.Font.Color;
end;

//-------------------------------------------------------------------------

Procedure TfrmTTDOffer.SetSampleControl (SampleControl : Text8pt);

  Procedure UpdateControlColours (DestControl : TComponent);
  Begin // UpdateControlColours
    If (DestControl Is TCurrencyEdit) Then
    Begin
      TCurrencyEdit(DestControl).Color := SampleControl.Color;
      TCurrencyEdit(DestControl).Font.Assign (SampleControl.Font);
    End; // If (DestControl Is TCurrencyEdit)
  End; // UpdateControlColours

Begin // SetSampleControl
  If Assigned(SampleControl) Then
  Begin
    UpdateControlColours(edtBeforeTotalCost);
    UpdateControlColours(edtBeforeNetTotal);
    UpdateControlColours(edtBeforeNetLessSettle);
    UpdateControlColours(edtAfterTotalCost);
    UpdateControlColours(edtAfterNetTotal);
    UpdateControlColours(edtAfterNetLessSettle);
    UpdateControlColours(edtDiscountApplied);
    UpdateControlColours(edtTTDPercentage);
    UpdateControlColours(edtTTDValue);

    If FTTDCalculator.HideCost Then
    Begin
      lblTotalCost.Font.Color := clBtnShadow;

      edtBeforeTotalCost.Color := clBtnFace;
      edtBeforeTotalCost.Font.Color := clBtnShadow;
      edtBeforeTotalCost.BlankOnZero := True;
      edtBeforeTotalCost.Value := 0.0;

      edtAfterTotalCost.Color := clBtnFace;
      edtAfterTotalCost.Font.Color := clBtnShadow;
      edtAfterTotalCost.BlankOnZero := True;
      edtAfterTotalCost.Value := 0.0;
    End; // If FTTDCalculator.HideCost

    If FTTDCalculator.IsPurchase Then
    Begin
      // Hide Net - Settle Disc as not necessary on purchase transactions
      lblNetLessSettle.Font.Color := clBtnShadow;

      edtBeforeNetLessSettle.Color := clBtnFace;
      edtBeforeNetLessSettle.Font.Color := clBtnShadow;
      edtBeforeNetLessSettle.BlankOnZero := True;
      edtBeforeNetLessSettle.Value := 0.0;

      edtAfterNetLessSettle.Color := clBtnFace;
      edtAfterNetLessSettle.Font.Color := clBtnShadow;
      edtAfterNetLessSettle.BlankOnZero := True;
      edtAfterNetLessSettle.Value := 0.0;
    End; // If FTTDCalculator.IsPurchase
  End; // If Assigned(SampleControl)
End; // SetSampleControl

//------------------------------

Procedure TfrmTTDOffer.SetTTDCalculator (Value : TTTDCalculator);
{$IFDEF TRADE}
Var
  oVBDOffer : Pointer;
{$ELSE}
Var
  oVBDOffer : TVBDListItem;
{$ENDIF}
Begin // SetTTDCalculator
  FTTDCalculator := Value;

  Caption := FTTDCalculator.OurRef + ' Total Transaction Discount';

  UpdateTotals;

{$IFDEF TRADE}
  oVBDOffer := nil;
{$ELSE}
  oVBDOffer := VBDList.GetOffer(FTTDCalculator.TransTotals[ttBeforeNetTotal]);
{$ENDIF}

  If (Not Assigned (oVBDOffer)) Then
  Begin
    panVBDNotifcation.Visible := False;
    panTTDOffer.Top := panVBDNotifcation.Top;
    Self.Height := Self.Height - panVBDNotifcation.Height;
  {$IFDEF TRADE}
  end;
  {$ELSE}
  End // If (Not Assigned (oVBDOffer))
  Else
    lblVBDOffer.Caption := oVBDOffer.Description + ' Value Based Discount is available for this transaction';
  {$ENDIF}

  // Default the options appropriately
  If FTTDCalculator.TTDExists Then
  Begin
    If (FTTDCalculator.TTDType = PcntChr) Then
    Begin
      // Percentage Discount
      radPercentageTTD.Checked := True;
      ActiveControl := radPercentageTTD;
      edtTTDPercentage.Text := Format ('%0.2f', [Round_Up(FTTDCalculator.TTDValue * 100, 2)]);
    End // If (FTTDCalculator.TTDType = PcntChr)
    Else
    Begin
      // Value Discount
      radValueTTD.Checked := True;
      ActiveControl := radValueTTD;
      edtTTDValue.Value := FTTDCalculator.TTDValue;
    End; // Else
  End // If FTTDCalculator.TTDExists
  Else
  Begin
    radNoTTD.Checked := True;
    ActiveControl := radNoTTD;
  End; // Else
  DoClickyClicky(Self);
End; // SetTTDCalculator

//------------------------------

Procedure TfrmTTDOffer.SetValidationError (Value : Boolean);
Begin // SetValidationError
  FValidationError := Value;
  btnApplyTTD.Enabled := Not FValidationError;
End; // SetValidationError

//-------------------------------------------------------------------------

Procedure TfrmTTDOffer.UpdateTotals;
Begin // UpdateTotals
  If (Not FTTDCalculator.HideCost) Then edtBeforeTotalCost.Value := FTTDCalculator.TransTotals[ttBeforeTotalCost];
  edtBeforeNetTotal.Value := FTTDCalculator.TransTotals[ttBeforeNetTotal];
  If (Not FTTDCalculator.IsPurchase) Then edtBeforeNetLessSettle.Value := FTTDCalculator.TransTotals[ttBeforeNetLessSettle];

  If (Not FTTDCalculator.HideCost) Then edtAfterTotalCost.Value := FTTDCalculator.TransTotals[ttAfterTotalCost];
  edtAfterNetTotal.Value := FTTDCalculator.TransTotals[ttAfterNetTotal];
  If (Not FTTDCalculator.IsPurchase) Then edtAfterNetLessSettle.Value := FTTDCalculator.TransTotals[ttAfterNetLessSettle];

  edtDiscountApplied.Value := ABS(Round_Up(FTTDCalculator.TransTotals[ttAfterNetTotal] - FTTDCalculator.TransTotals[ttBeforeNetTotal], 2));

  If (Round_Up(FTTDCalculator.AmountDiscountRequested,2) <> Round_Up(edtDiscountApplied.Value,2)) Then
  Begin
    tmBlinky.Enabled := True;
    lblDiscountApplied.Hint := Format('%0.2f', [FTTDCalculator.AmountDiscountRequested]);
  End // If (FTTDCalculator.AmountDiscountRequested <> edtDiscountApplied.Value)
  Else
  Begin
    tmBlinky.Enabled := False;
    edtDiscountApplied.Font.Color := edtBeforeNetTotal.Font.Color;
  End; // Else
End; // UpdateTotals

//-------------------------------------------------------------------------

procedure TfrmTTDOffer.btnApplyTTDClick(Sender: TObject);
begin
  btnApplyTTD.Enabled := False;

  // Validate settings and update transaction
  If radNoTTD.Checked Then
  Begin
    // No new discount - remove any pre-existing TTD
    If FTTDCalculator.TTDExists Then
    Begin
      FTTDCalculator.RemoveTTD;
      ModalResult := mrOK;
    End // If FTTDCalculator.TTDExists
    Else
      ModalResult := mrCancel;
  End // If radNoTTD.Checked
  Else If radPercentageTTD.Checked Then
  Begin
    // Validation?
    FTTDCalculator.ApplyTTD;
    ModalResult := mrOK;
  End // If radPercentageTTD.Checked
  Else If radValueTTD.Checked Then
  Begin
    FTTDCalculator.ApplyTTD;
    ModalResult := mrOK;
  End; // If radValueTTD.Checked

  btnApplyTTD.Enabled := (Not ModalResult In [mrOK, mrCancel]);
end;

//-------------------------------------------------------------------------

procedure TfrmTTDOffer.DoClickyClicky(Sender: TObject);
begin
  edtTTDPercentage.Enabled := radPercentageTTD.Checked;
  edtTTDPercentage.Color := IfThen (edtTTDPercentage.Enabled, edtBeforeNetTotal.Color, clBtnFace);
  edtTTDPercentage.TabStop := edtTTDPercentage.Enabled;
  If (Not edtTTDPercentage.Enabled) Then
  Begin
    // Bodge to fix painting issue
    edtTTDPercentage.Visible := False;
    edtTTDPercentage.Visible := True;
  End; // If (Not edtTTDPercentage.Enabled)

  edtTTDValue.Enabled := radValueTTD.Checked;
  edtTTDValue.Color := IfThen (edtTTDValue.Enabled, edtBeforeNetTotal.Color, clBtnFace);
  edtTTDValue.TabStop := edtTTDValue.Enabled;
  If (Not edtTTDValue.Enabled) Then
  Begin
    // Bodge to fix painting issue
    edtTTDValue.Visible := False;
    edtTTDValue.Visible := True;
  End; // If (Not edtTTDValue.Enabled)

  If radNoTTD.Checked Then
  Begin
    ValidationError := False;
    FTTDCalculator.CalculateAD(0.0, PcntChr);
    UpdateTotals;
  End // If radNoTTD.Checked
  Else If radPercentageTTD.Checked Then
    edtTTDPercentageChange(Self)
  Else If radValueTTD.Checked Then
    edtTTDValueChange(Self);
end;

//-------------------------------------------------------------------------

function TfrmTTDOffer.RemoveBadChars(BadString : ShortString) : ShortString;
Const
  BadCharSet = [#10, #13, ','];
Var
  iChar : Byte;
Begin // RemoveBadChars
  Result := '';

  For iChar := 1 To Length(BadString) Do
    If Not (BadString[iChar] In BadCharSet) Then
      // Switch minus sign to start of string otherwise it doesn't convert properly
      If (BadString[iChar] = '-') Then
        Result := BadString[iChar] + Result
      Else
        Result := Result + BadString[iChar];
End; // RemoveBadChars


//-------------------------------------------------------------------------

procedure TfrmTTDOffer.edtTTDPercentageKeyPress(Sender: TObject; var Key: Char);
begin
  If (Not (Key In [#8, '0'..'9', '.'])) Then
    Key := #0;
end;

//------------------------------

procedure TfrmTTDOffer.edtTTDPercentageChange(Sender: TObject);
Var
  PercValue : Double;
  sValue : ShortString;
begin
  If (ActiveControl <> btnCancel) Then
  Begin
    // NOTE: the Value property only updates OnExit so need to convert the text property to get
    // the value, also sometimes it has a #13#10 on the end (god knows why!) which causes the
    // StrToFloatDef function to return 0!
    //sValue := StringReplace(StringReplace(edtTTDPercentage.Text, #13, '', [rfReplaceAll]), #10, '', [rfReplaceAll]);
    sValue := RemoveBadChars(edtTTDPercentage.Text);
    PercValue := StrToFloatDef (sValue, 0);

    If FTTDCalculator.ValidPercentageDiscount (PercValue) Then
    Begin
      ValidationError := False;
      If (Not FTTDCalculator.CalculateAD(PercValue, PcntChr)) Then
      Begin
        // Gone below cost or negative
        ValidationError := True;
        //If edtTTDPercentage.CanFocus Then edtTTDPercentage.SetFocus;
      End; // If (Not FTTDCalculator.CalculateAD(PercValue, PcntChr))
    End // If FTTDCalculator.ValidPercentageDiscount (PercValue)
    Else
    Begin
      ValidationError := True;
      FTTDCalculator.CalculateAD(0, PcntChr);
      MessageDlg ('The Percentage TTD must be within the range of 0% to 100%', mtError, [mbOK], 0);
    End; // Else

    UpdateTotals;
  End; // If (ActiveControl <> btnCancel)
end;

//------------------------------

procedure TfrmTTDOffer.edtTTDValueKeyPress(Sender: TObject; var Key: Char);
begin
  If (Not (Key In [#8, '0'..'9', '.', '-'])) Then
    Key := #0;
end;

//------------------------------

procedure TfrmTTDOffer.edtTTDValueChange(Sender: TObject);
Var
  AmountValue : Double;
  sValue : ShortString;
begin
  If (ActiveControl <> btnCancel) Then
  Begin
    // NOTE: the Value property only updates OnExit so need to convert the text property to get
    // the value, also sometimes it has a #13#10 on the end (god knows why!) which causes the
    // StrToFloatDef function to return 0!
    //sValue := StringReplace(StringReplace(edtTTDValue.Text, #13, '', [rfReplaceAll]), #10, '', [rfReplaceAll]);
    sValue := RemoveBadChars(edtTTDValue.Text);
    AmountValue := StrToFloatDef (sValue, 0);
    If FTTDCalculator.ValidValueDiscount (AmountValue) Then
    Begin
      ValidationError := False;
      If (Not FTTDCalculator.CalculateAD(AmountValue, #0)) Then
      Begin
        // Gone below cost or negative
        ValidationError := True;
        //If edtTTDValue.CanFocus Then edtTTDValue.SetFocus;
      End; // If (Not FTTDCalculator.CalculateAD(AmountValue, #0))
    End // If FTTDCalculator.ValidValueDiscount (AmountValue)
    Else
    Begin
      ValidationError := True;
      FTTDCalculator.CalculateAD(0, PcntChr);
      MessageDlg ('The Value TTD must be between 0.0 and ' + Format('%0.2f', [FTTDCalculator.TransTotals[ttBeforeNetTotal]]) + ' inclusive', mtError, [mbOK], 0);
    End; // Else

    UpdateTotals;
  End; // If (ActiveControl <> btnCancel)
end;

//=========================================================================

end.

