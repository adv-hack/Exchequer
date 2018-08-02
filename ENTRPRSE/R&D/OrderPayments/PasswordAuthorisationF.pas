unit PasswordAuthorisationF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  GlobVar, VarConst, StdCtrls, Math, ExtCtrls, TEditVal, Mask, EnterToTab;

type
  //PR: 08/01/2015 Added fmMatchDeallocation member to the enumeration. This is for situations where
  //               a user is trying to unallocate an invoice which is matched to any OP payments.
  enumfrmOrderPaymentsPasswordRequiredMode = (fmPaymentAllocation, fmPaymentDeallocation,
                                              fmRefundAllocation, fmRefundDeallocation,
                                              fmMatchedDeallocation);

  //------------------------------

  TfrmOrderPaymentsPasswordRequired = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    btnHelp: TButton;
    Image1: TImage;
    edtPassword: Text8Pt;
    Label1: TLabel;
    CLMsgL: Label8;
    Label86: Label8;
    lblWarning: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
  private
    { Private declarations }
    FMode : enumfrmOrderPaymentsPasswordRequiredMode;
    Procedure SetMode (Value : enumfrmOrderPaymentsPasswordRequiredMode);
  public
    { Public declarations }
    Property Mode : enumfrmOrderPaymentsPasswordRequiredMode Read FMode Write SetMode;
  end;


// Returns TRUE if the user chooses to continue and Reverse the Transaction
Function OrdPay_OKToReverse (Const Trans : InvRec) : Boolean;

// Returns TRUE if the Transaction can be allocated/unallocated
Function OrdPay_OKToAllocate (Const Owner : TForm; Const Trans : InvRec; Const Allocation : Boolean) : Boolean;

implementation

{$R *.dfm}

Uses HelpContextIds,
     SecSup2U,     // Daily Password function
     ExWrap1u,
     BtKeys1U,
     BtrvU2,
     BtSupu1;

//=========================================================================

// Returns TRUE if the user chooses to continue and Reverse the Transaction
Function OrdPay_OKToReverse (Const Trans : InvRec) : Boolean;
Begin // OrdPay_OKToReverse
  If (Trans.thOrderPaymentElement In OrderPayment_PaymentSet) Then
    // SOR/SDN/SIN Payment
    Result := (MessageDlg ('This payment was created using Order Payments.' +
                           #13#10#13#10 +
                           'To refund the payment you should use the Refund functionality from ' + Trim(Trans.thOrderPaymentOrderRef) + '.  ' +
                           'If you continue the reversed transaction will be created outside of the Order Payments system.' +
                           #13#10#13#10 +
                           'Do you want to continue?', mtConfirmation, [mbYes, mbNo], 0) = mrYes)
  Else If (Trans.thOrderPaymentElement In OrderPayment_RefundSet) Then
    // SOR/SIN Refund
    Result := (MessageDlg ('This transaction was created using Order Payments.' +
                           #13#10#13#10 +
                           'If you continue the reversed transaction will be created outside of the Order Payments system.' +
                           #13#10#13#10 +
                           'Do you want to continue?', mtConfirmation, [mbYes, mbNo], 0) = mrYes)
  Else
    // Everything Else...
    Result := True;
End; // OrdPay_OKToReverse

//=========================================================================
//PR: 08/01/2015 Function to check if oTrans is matched to any OP transactions
function MatchedToOPTransaction(oTrans : InvRec) : Boolean;
var
  Res : Integer;
  KeyS : Str255;
  KeyCheck : Str255;

  InvRes : Integer;
  InvKeyS : Str255;
  InvKeyCheck : Str255;

  Idx : Integer;

  TmpStat : Integer;
  TmpKPath : Integer;
  TmpRecAddr : Integer;

  InvTmpStat : Integer;
  InvTmpKPath : Integer;
  InvTmpRecAddr : Integer;

  ExLocal : TdExLocalPtr;

  AClientId : Integer;
begin
  Result := False;

  New(ExLocal, Create);

  Try
    with ExLocal^ do
    begin
      //Save position in Password (matching) file.
      TmpKPath := GetPosKey;
      LPresrv_BTPos(PwrdF,TmpKPath,F[PwrdF],TmpRecAddr,BOff,BOff);

      //Preserve position in doc file
      InvTmpKPath := GetPosKey;
      LPresrv_BTPos(InvF,InvTmpKPath,F[InvF],InvTmpRecAddr,BOff,BOff);


      //Set search key
      KeyCheck := FullMatchKey(MatchTCode, MatchSCode, oTrans.OurRef);

      //Reset search key
      KeyS := KeyCheck;

      //Find first match record
      Res := Find_Rec(B_GetGEq, F[PwrdF], PWrdF, LRecPtr[PWrdF]^, PWK, KeyS);

      while (not Result) and (Res = 0) and CheckKey(KeyCheck, KeyS, Length(keyCheck), True) do
      with LPassword.MatchPayRec do
      begin

        //Financial Matching only
        if MatchType = 'A' then
        begin
          InvKeyS := PayRef;

          //Find transaction
          InvRes := Find_Rec(B_GetEq, F[InvF], InvF, LRecPtr[InvF]^, InvOurRefK, InvKeyS);

          //If transaction found and it's an order payment transaction then set result to true
          Result := (InvRes = 0) and (LInv.thOrderPaymentElement <> opeNA);

        end; //if MatchType = 'A'


        if not Result then //Get next matching rec
          Res := Find_Rec(B_GetNext, F[PwrdF], PWrdF, LRecPtr[PWrdF]^, PWK, KeyS);
      end; //while (not Result) and (Res = 0)

    end; //with MTExLocal
  Finally

    //Restore positions in file
    ExLocal.LPresrv_BTPos(PwrdF,TmpKPath,F[PwrdF],TmpRecAddr,BOn,BOff);

    ExLocal.LPresrv_BTPos(InvF,InvTmpKPath,F[InvF],InvTmpRecAddr,BOn,BOff);

    Dispose(ExLocal, Destroy);
  End;
end;


//=========================================================================
// Returns TRUE if the Transaction can be allocated/unallocated
Function OrdPay_OKToAllocate (Const Owner : TForm; Const Trans : InvRec; Const Allocation : Boolean) : Boolean;
var
  frmOrderPaymentsPasswordRequired : TfrmOrderPaymentsPasswordRequired;
  bRequirePassword : Boolean;
Begin // OrdPay_OKToAllocate
  If (Trans.thOrderPaymentElement In OrderPayment_PaymentSet) Then
    // Always ask for the password for Allocating or De-Allocating Payments
    bRequirePassword := True
  Else If (Trans.thOrderPaymentElement In OrderPayment_RefundSet) Then
    // Always need a password to De-allocate refunds
    // Refunds can be freely allocated as they have been previously de-allocated
    bRequirePassword := (Not Allocation)
  Else if (Trans.thOrderPaymentElement = opeInvoice) then
    //PR: 08/01/2015 If invoice is matched to OP payment then need a password
    bRequirePassword := MatchedToOPTransaction(Trans)
  else
    bRequirePassword := False;

  If bRequirePassword Then
  Begin
    // Display Daily Password dialog
    frmOrderPaymentsPasswordRequired := TfrmOrderPaymentsPasswordRequired.Create(Owner);
    Try
      If (Trans.thOrderPaymentElement In OrderPayment_PaymentSet) Then
      Begin
        If Allocation Then
          frmOrderPaymentsPasswordRequired.Mode := fmPaymentAllocation
        Else
          frmOrderPaymentsPasswordRequired.Mode := fmPaymentDeallocation
      End
      Else if (Trans.thOrderPaymentElement In OrderPayment_RefundSet) then
      Begin
        If Allocation Then
          frmOrderPaymentsPasswordRequired.Mode := fmRefundAllocation
        Else
          frmOrderPaymentsPasswordRequired.Mode := fmRefundDeallocation;
      End // Else
      else
        //PR: 08/01/2015 - use new enumeration member for deallocating invoice matched to OP payment
        frmOrderPaymentsPasswordRequired.Mode := fmMatchedDeallocation;

      Result := (frmOrderPaymentsPasswordRequired.ShowModal = mrOK);
    Finally
      frmOrderPaymentsPasswordRequired.Free;
    End; // Try..Finally
  End
  Else
    Result := True;
End; // OrdPay_OKToAllocate

//=========================================================================

procedure TfrmOrderPaymentsPasswordRequired.FormCreate(Sender: TObject);
Var
  PointRec : TPoint;
  BMap1 : TBitMap;
  RectD : TRect;
begin
  // Note: As this form is not an MDI Child the automatic routines for centring over the owner don't work properly.
  PointRec := Application.MainForm.ClientToScreen(Point(TForm(Owner).Left, TForm(Owner).Top));
  // Need to adjust the top as the header of the main window doesn't appear to be taken into account for some reason
  // This isn't quite right, but I don't have time to work out what the issue is - it is pretty close
  // Additional: If we reference EParentU from this unit then we get a licensing error on startup
  Top := PointRec.Y + ((TForm(Owner).Height - Self.Height) Div 2) + ((Application.MainForm.Height - Application.MainForm.ClientHeight) Div 2);
  Left := PointRec.X + ((TForm(Owner).Width - Self.Width) Div 2);

  // Copy in the warning graphic from the resources
  If (Not NoXLogo) Then
  Begin
    BMap1:=TBitMap.Create;
    Try
      BMap1.Handle:=LoadBitMap(HInstance,'EXCLAM_2');
      RectD:=Rect(0, 0, BMap1.Width, BMap1.Height);
      With Image1.Picture.Bitmap do
      Begin
        Width := BMap1.Width;
        Height := BMap1.Height;

        Canvas.Brush.Color := clBtnFace;
        Canvas.BrushCopy (RectD, BMap1, RectD, clSilver);
      End; // With Image1.Picture.Bitmap
    Finally
      BMap1.Free;
    End; // Try..Finally
  End; // If (Not NoXLogo)
end;

//-------------------------------------------------------------------------

Procedure TfrmOrderPaymentsPasswordRequired.SetMode (Value : enumfrmOrderPaymentsPasswordRequiredMode);
Var
  S1, S2 : ANSIString;
Begin // SetMode
  // Configure the window
  FMode := Value;
  Case FMode Of
    fmPaymentAllocation    : Begin
                               S1 := 'allocate';
                               S2 := 'payment';
                             End; // fmPaymentAllocation
    fmPaymentDeallocation  : Begin
                               S1 := 'unallocate';
                               S2 := 'payment';
                             End; // fmPaymentDeallocation
    fmRefundAllocation     : Begin
                               S1 := 'allocate';
                               S2 := 'refund';
                             End; // fmRefundAllocation
    fmRefundDeallocation   : Begin
                               S1 := 'unallocate';
                               S2 := 'refund';
                             End; // fmRefundDeallocation
    fmMatchedDeallocation  : Begin
                               S1 := 'unallocate';
                               S2 := 'transaction matched to a payment';
                             End;
  Else
    Raise Exception.Create ('TfrmOrderPaymentsPasswordRequired.SetMode: Unhandled Mode (' + IntToStr(Ord(Mode)) + ')');
  End; // Case FMode

  lblWarning.Caption := 'You are trying to manually ' + S1 + ' a ' + S2 + ' created using the ' +
                        'Order Payments sub-system.';

End; // SetMode

//-------------------------------------------------------------------------

procedure TfrmOrderPaymentsPasswordRequired.btnOKClick(Sender: TObject);
begin
  // Check for Daily Password
  If (edtPassWord.Text = Get_TodaySecurity) Then
    ModalResult := mrOK
  Else
  Begin
    If edtPassWord.CanFocus Then
      edtPassWord.SetFocus;
    MessageDlg ('The Password is not correct', mtError, [mbOK], 0);
  End; // Else
end;

//------------------------------

procedure TfrmOrderPaymentsPasswordRequired.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

//------------------------------

procedure TfrmOrderPaymentsPasswordRequired.btnHelpClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT, Self.HelpContext);
end;

//-------------------------------------------------------------------------

end.
