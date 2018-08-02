Unit oOrderPaymentsRefundManager;

Interface

Uses Classes, SysUtils, StrUtils, GlobVar, VarConst, ExBTTh1U, OrderPaymentsInterfaces,
     oCreditCardGateway, oOPVATPayMemoryList, oOrderPaymentsSRC {$IFNDEF EXDLL}, SerialNoFrame, SerialNoF {$ENDIF};

Type
  Str50 = String[50];

  // Note: Must map onto the item indexes in the drop-down list on the refund dialog
  TRefundManagerRefundType = (rtValueOnly=0, rtValueAndStock=1);

  TOrderPaymentsRefundManager = Class(TObject)
  Private
    FExLocal : TdPostExLocalPtr;

    FPaymentInfo : IOrderPaymentsTransactionPaymentInfo;
    FPaymentTransaction : IOrderPaymentsTransactionPaymentInfoPaymentHeader;
    FRefundType : TRefundManagerRefundType;
    FCreditCardAction : enumCreditCardAction;
    FRefundReason : Str50;

    FRefundSRC : IOrderPaymentsSRC;
    FRefundSRF : IOrderPaymentsSRF;

    FSerialBatchList : TStringList;

    {$IFNDEF EXDLL}
    SerialNoForm : TfrmSerialNos;
    {$ENDIF}

    Procedure SetPaymentInfo (Value : IOrderPaymentsTransactionPaymentInfo);
    Procedure SetPaymentTransaction (Value : IOrderPaymentsTransactionPaymentInfoPaymentHeader);

    Function CreateRefundSummary : TOrderPaymentsVATPayDetailsList;

    // Executes whatever Credit Card Operations are required
    //
    //   0    Success
    //
    Function ExecuteCreditCardOperation (Const RefundSummary : TOrderPaymentsVATPayDetailsList) : Integer;

    // Adds the description lines for the Refund into OPVATPay.Dat
    //
    //  0           AOK
    //  1000-1999  Error opening OPVATPay.Dat
    //  2000-2999  Error inserting summary row
    //  3000-3999  Error inserting transaction line row
    //  4000-4999  Error inserting transaction Stock Description line row
    Function WriteRefundDetails (Const RefundRef : ShortString; Const RefundSummary : TOrderPaymentsVATPayDetailsList) : Integer;

    //Creates the negative SRC
    Function CreateSRC : Integer;
    Function CreateSRF : Integer;

    function WantSerialNos(const StockCode : string) : Boolean;
    {$IFNDEF EXDLL}
    procedure ProcessSerialBatchFrame(const AFrame : TframeSerialNo);
    {$ENDIF EXDLL}
    procedure UnlockSerialBatchRecords;
  Public
    Property rmPaymentInfo : IOrderPaymentsTransactionPaymentInfo Read FPaymentInfo Write SetPaymentInfo;
    Property rmPaymentTransaction : IOrderPaymentsTransactionPaymentInfoPaymentHeader Read FPaymentTransaction Write SetPaymentTransaction;
    Property rmRefundType : TRefundManagerRefundType Read FRefundType Write FRefundType;
    Property rmCreditCardAction : enumCreditCardAction Read FCreditCardAction Write FCreditCardAction;
    Property rmRefundReason : Str50 Read FRefundReason Write FRefundReason;

    Constructor Create (ExLocal : TdPostExLocalPtr);
    Destructor Destroy; Override;

    Function ExecuteRefund : Integer;
    Function GetSerialNos : Boolean;
  End; // TOrderPaymentsRefundManager

Implementation

Uses oBtrieveFile, oOPVATPayBtrieveFile, ETMiscU, ETStrU, BtrvU2, Math, VarRec2U, Dialogs, Forms, BtKeys1U, Controls,
  MathUtil, CurrncyU;

//=========================================================================

Constructor TOrderPaymentsRefundManager.Create (ExLocal : TdPostExLocalPtr);
Begin // Create
  Inherited Create;

  FExLocal := ExLocal;

  FPaymentInfo := NIL;
  FPaymentTransaction := NIL;
  FRefundType := rtValueOnly;
  FCreditCardAction := ccaNoAction;
  FRefundReason := '';

  FSerialBatchList := TStringList.Create;
  FSerialBatchList.Sorted := True;
  FSerialBatchList.Duplicates := dupAccept;
End; // Create

Destructor TOrderPaymentsRefundManager.Destroy;
var
  i : Integer;
Begin // Destroy
  FPaymentInfo := NIL;
  FPaymentTransaction := NIL;
  Inherited Destroy;

  FSerialBatchList.Free;
End; // Destroy

//-------------------------------------------------------------------------

Procedure TOrderPaymentsRefundManager.SetPaymentInfo (Value : IOrderPaymentsTransactionPaymentInfo);
Begin // SetPaymentInfo
  FPaymentInfo := Value;
End; // SetPaymentInfo

//------------------------------

Procedure TOrderPaymentsRefundManager.SetPaymentTransaction (Value : IOrderPaymentsTransactionPaymentInfoPaymentHeader);
Begin // SetPaymentInfo
  FPaymentTransaction := Value;
End; // SetPaymentInfo

//-------------------------------------------------------------------------

// Generates a Refund against the payment (FPaymentInfo.Payment)
//
//   0      Success
//   999    Unknown Error
Function TOrderPaymentsRefundManager.ExecuteRefund : Integer;
Var
  oRefundSummary : TOrderPaymentsVATPayDetailsList;
  RefundSRCRef : ShortString;
  iStatus, Res, i : Integer;
  KeyS : Str255;

  {$IFNDEF EXDLL}
  SerialNoForm : TfrmSerialNos;
  {$ENDIF EXDLL}
Begin // ExecuteRefund
  Res := 999;

  // Check there is a value to refund
  If (FPaymentTransaction.opphRefundValue > 0.0) Then
  Begin
    // Create a summary of the details to be written to OPVATPay if the Credit Card
    // and Refund operations succeed, this can then be used by the Credit Card operation
    // as well
    oRefundSummary := CreateRefundSummary;
    Try
      // Execute any required Credit Card operation
      Res := ExecuteCreditCardOperation (oRefundSummary);
      If (Res = 0) Then
      Begin

        //Open files for stock, location and FIFO
        FExLocal.Open_System(StockF, StockF);
        FExLocal.Open_System(MLocF, MLocF);
        FExLocal.Open_System(MiscF, MiscF);

        // Begin Database Transaction
        iStatus := FPaymentInfo.ExLocal.LCtrl_BTrans(1);  // Start Database Transaction

        If (rmRefundType = rtValueAndStock) Then
        begin
          {$IFNDEF EXDLL}
          GetSerialNos;
          {$ENDIF EXDLL}

          // Create SRF to refund the stock and value
          iStatus := CreateSRF;

          if iStatus = 0 then
            RefundSRCRef := FRefundSRF.OurRef;
        end
        Else
        begin
          // Create SRC to refund the value only
          iStatus := CreateSRC;

          if iStatus = 0 then
            RefundSRCRef := FRefundSRC.OurRef
          else;
            //TODO: Error handling
        end;

        // Insert OPVATPay details via emulator so it is included within the Database Transaction
        if iStatus = 0 then
          iStatus := WriteRefundDetails (RefundSRCRef, oRefundSummary);

        // End Transaction - Commit or Cancel
        if iStatus = 0 then
          iStatus := FPaymentInfo.ExLocal.LCtrl_BTrans(0)  // End Database Transaction
        else
        begin
          iStatus := FPaymentInfo.ExLocal.LCtrl_BTrans(2);  // Abort Database Transaction

          //TODO: Handle error
        end;

        UnlockSerialBatchRecords;

        If (iStatus = 0) Then
          Res := 0;
      End // If (Res = 0)
      Else
        ; // TODO: Handle Error - how? exception? error code back to calling routine?
    Finally
      FreeAndNIL(oRefundSummary);
      FRefundSRC := nil;
    End; // Try..Finally
  End // If (FPaymentHeaderInfo.FPaymentTransaction > 0.0)
  Else
    ; // TODO: Handle Error - how? exception? error code back to calling routine?

  Result := Res;
End; // ExecuteRefund

//-------------------------------------------------------------------------

// Executes whatever Credit Card Operations are required
//
//   0    Success
//
Function TOrderPaymentsRefundManager.ExecuteCreditCardOperation (Const RefundSummary : TOrderPaymentsVATPayDetailsList) : Integer;
Begin // ExecuteCreditCardOperation
  If (FCreditCardAction <> ccaNoAction) Then
  Begin
// TODO: (PKR) Implement Credit Card Payment / Authorisation here
    Result := 0;
  End // If (FCreditCardAction <> ccaNoAction)
  Else
    // No action required - return successfull status
    Result := 0;
End; // ExecuteCreditCardOperation

//-------------------------------------------------------------------------

Function TOrderPaymentsRefundManager.CreateRefundSummary : TOrderPaymentsVATPayDetailsList;
Var
  SummaryVATPayRec, VATPayRec : OrderPaymentsVATPayDetailsRecType;
  PaymentLineIntf : IOrderPaymentsTransactionPaymentInfoPaymentLine;
  sPreDesc, sSuffDesc : ShortString;
  LineCount, I : Integer;
Begin // CreateRefundSummary
  // Create the refund summary object
  Result := TOrderPaymentsVATPayDetailsList.Create;

  // Create Refund summary line ----------------------------------------------
  FillChar(SummaryVATPayRec, SizeOf(SummaryVATPayRec), #0);
  With SummaryVATPayRec Do
  Begin
    // SOR OurRef - originating order that all Order Payment transactions originate from
    If (FPaymentInfo.optTransaction.InvDocHed = SOR) Then
      vpOrderRef := LJVar(FPaymentInfo.optTransaction.OurRef, SizeOf(vpOrderRef) - 1)
    Else
      vpOrderRef := LJVar(FPaymentInfo.optTransaction.thOrderPaymentOrderRef, SizeOf(vpOrderRef) - 1);

    // OurRef (SRC/SRF) of Refund transaction
    vpReceiptRef := '';  // Not known at this point

    // OurRef of payment being refunded
    vpTransRef := LJVar(FPaymentTransaction.opphPayment.OurRef, SizeOf(vpTransRef) - 1);

    // Line sequence within OPVATPAY
    vpLineOrderNo   := 1;

    // Absolute Line Number from SOR, maps onto SOPLineNo on SDN/SIN
    vpSORABSLineNo  := 0;

    // Operation type / purpose
    If (FPaymentInfo.optTransaction.InvDocHed = SOR) Then
      // Refund against an SOR
      vpType := vptSORValueRefund
    Else If (FPaymentInfo.optTransaction.InvDocHed = SIN) And (rmRefundType = rtValueAndStock) Then
      // Stock Refund against an SIN - SRF generated instead of -SRC
      vpType := vptSINStockRefund
    Else If (FPaymentInfo.optTransaction.InvDocHed = SIN) And (rmRefundType = rtValueOnly) Then
      // Value Refund against an SIN - generates -SRC
      vpType := vptSINValueRefund
    Else
      Raise Exception.Create ('TOrderPaymentsRefundManager.CreateRefundSummary: Unsupported Transaction Type (' + IntToStr(Ord(FPaymentInfo.optTransaction.InvDocHed)) + ')');

    // SOR Currency and therefore SDN/SIN/SRC currency
    vpCurrency := FPaymentInfo.optTransaction.Currency;

    // Text description of SOR line for printing VAT Receipts, e.g. £666.66 Part Payment against SORxxxxxx/SINxxxxxx
    vpDescription := FPaymentTransaction.opphCurrencySymbol + Form_Real(FPaymentTransaction.opphRefundValue,0,2) + ' ' +
                     IfThen (FPaymentTransaction.opphRefundValue = FPaymentTransaction.opphNetValue, 'Full', 'Part') + ' Refund against ' +
                     Trim(vpOrderRef) + '/' + Trim(vpTransRef);

    // Exchequer User at point row inserted
    vpUserName := EntryRec^.Login;
    // Date row inserted in YYYYMMDD format
    vpDateCreated := FormatDateTime ('yyyymmdd', Now);
    // Time row inserted in HHMMSS format
    vpTimeCreated := FormatDateTime ('hhnnss', Now);
  End; // With SummaryVATPayRec
  Result.Add(SummaryVATPayRec);

  // Create Payment line details ----------------------------------------------
  LineCount := 2;
  For I := 0 To (FPaymentTransaction.opphPaymentLineCount - 1) Do
  Begin
    PaymentLineIntf := FPaymentTransaction.opphPaymentLines[I];
    If PaymentLineIntf.opplRefundSelected And (PaymentLineIntf.opplRefundValue <> 0.0) Then
    Begin
      // Add Line for Stock Code / Price ------------------
      FillChar(VATPayRec, SizeOf(VATPayRec), #0);
      With VATPayRec Do
      Begin
        // Copy details in from summary line
        vpOrderRef := SummaryVATPayRec.vpOrderRef;
        vpReceiptRef := SummaryVATPayRec.vpReceiptRef;
        vpTransRef := SummaryVATPayRec.vpTransRef;
        vpType := SummaryVATPayRec.vpType;
        vpCurrency := SummaryVATPayRec.vpCurrency;
        vpUserName := SummaryVATPayRec.vpUserName;
        vpDateCreated := SummaryVATPayRec.vpDateCreated;
        vpTimeCreated := SummaryVATPayRec.vpTimeCreated;

        // Line sequence within OPVATPAY within this payment
        vpLineOrderNo := LineCount;
        LineCount := LineCount + 1;

        // Absolute Line Number from SOR, maps onto SOPLineNo on SDN/SIN
        vpSORABSLineNo := PaymentLineIntf.opplOrderLine.opolLine.ABSLineNo;

        If (Trim(PaymentLineIntf.opplOrderLine.opolLine.StockCode) <> '') Then
        Begin
          // Text description of SOR line for printing VAT Receipts, e.g. 10 x STUFF @ £100.00
          vpDescription := Form_Real (PaymentLineIntf.opplOrderLine.opolLine.Qty, 0, Syss.NoQtyDec) + ' x ' +
                           Trim(PaymentLineIntf.opplOrderLine.opolLine.StockCode) + ' @ ' +
                           Form_Real (PaymentLineIntf.opplOrderLine.opolUnitPrice, 0, Syss.NoNetDec);
        End // If (Trim(PaymentLineIntf.opplOrderLine.opolLine.StockCode) <> '')
        Else
        Begin
          // Stock Code blank - Use the description instead - may need jiggery pokery to make it fit
          sPreDesc := Form_Real (PaymentLineIntf.opplOrderLine.opolLine.Qty, 0, Syss.NoQtyDec) + ' x ';
          sSuffDesc := ' @ ' + Form_Real (PaymentLineIntf.opplOrderLine.opolUnitPrice, 0, Syss.NoNetDec);
          vpDescription := sPreDesc + Copy(PaymentLineIntf.opplOrderLine.opolLine.Desc, 1, 50 - Length(sPreDesc) - Length(sSuffDesc))  + sSuffDesc;
        End; // Else

        // SOR Line VAT Code
        vpVATCode := PaymentLineIntf.opplOrderLine.opolLine.VATCode;

        // Goods Value paid/refunded
        vpGoodsValue := PaymentLineIntf.opplRefundGoods;
        // VAT Value paid/refunded
        vpVATValue := PaymentLineIntf.opplRefundVAT;
      End; // With VATPayRec
      Result.Add(VATPayRec);

      // Add Line for Stock Description -------------------
      If (Trim(PaymentLineIntf.opplOrderLine.opolLine.StockCode) <> '') Then
      Begin
        FillChar(VATPayRec, SizeOf(VATPayRec), #0);
        With VATPayRec Do
        Begin
          // Copy details in from summary line
          vpOrderRef := SummaryVATPayRec.vpOrderRef;
          vpReceiptRef := SummaryVATPayRec.vpReceiptRef;
          vpTransRef := SummaryVATPayRec.vpTransRef;
          vpType := SummaryVATPayRec.vpType;
          vpCurrency := SummaryVATPayRec.vpCurrency;
          vpUserName := SummaryVATPayRec.vpUserName;
          vpDateCreated := SummaryVATPayRec.vpDateCreated;
          vpTimeCreated := SummaryVATPayRec.vpTimeCreated;

          // Line sequence within OPVATPAY within this payment
          vpLineOrderNo := LineCount;
          LineCount := LineCount + 1;

          // Text description of SOR line for printing VAT Receipts, e.g. 10 x STUFF @ £100.00
          vpDescription := PaymentLineIntf.opplOrderLine.opolLine.Desc;
        End; // With VATPayBtrieveFile.VATPayDetails
        Result.Add(VATPayRec);
      End; // If (Trim(PaymentLineIntf.opplOrderLine.opolLine.StockCode) <> '')
    End; // If PaymentLineIntf.opplRefundSelected And (PaymentLineIntf.opplRefundValue <> 0.0)
  End; // For I
End; // CreateRefundSummary

//-------------------------------------------------------------------------

// Adds the description lines for the Refund into OPVATPay.Dat
//
//  0           AOK
//  1000-1999  Error opening OPVATPay.Dat
//  2000-2999  Error inserting row
//
Function TOrderPaymentsRefundManager.WriteRefundDetails (Const RefundRef : ShortString; Const RefundSummary : TOrderPaymentsVATPayDetailsList) : Integer;
Var
  VATPayBtrieveFile : TOrderPaymentsVATPayDetailsBtrieveFile;
  I, iStatus : Integer;
Begin // WriteRefundDetails
  Result := 0;    // AOK

  // Create a Btrieve File Object for OPVATPay.Dat using the same Client Id as the ExLocal instance we are using.
  VATPayBtrieveFile := TOrderPaymentsVATPayDetailsBtrieveFile.CreateWithClientId (oBtrieveFile.ClientIdType(FExLocal.ExClientId^));
  Try
    iStatus := VATPayBtrieveFile.OpenFile (SetDrive + OrderPaymentsVATPayDetailsFilePath);
    If (iStatus = 0) Then
    Begin
      For I := 0 To (RefundSummary.Count - 1) Do
      Begin
        VATPayBtrieveFile.InitialiseRecord;
        VATPayBtrieveFile.VATPayDetails := RefundSummary.Records[I];
        With VATPayBtrieveFile.VATPayDetails Do
          vpReceiptRef := LJVar(RefundRef, SizeOf(vpReceiptRef) - 1);
        iStatus := VATPayBtrieveFile.Insert;
        If (iStatus <> 0) Then
          Result := 2000 + iStatus;
      End; // For I

      VATPayBtrieveFile.CloseFile(False);  // Don't reset the ClientId as that will screw up the ExLocal
    End // If (iStatus = 0)
    Else
      // Error opening OPVATPay.Dat
      Result := 1000 + iStatus;
  Finally
    VATPayBtrieveFile.Free;
  End; // Try..Finally
End; // WriteRefundDetails

//-------------------------------------------------------------------------
//Creates the negative SRC
Function TOrderPaymentsRefundManager.CreateSRC : Integer;
var
  Res : Integer;
  KeyS : Str255;
  PayCount : Integer;

  function GetOrderPaymentElement(const DocType : DocTypes) : enumOrderPaymentElement;
  begin
    Case DocType of
       SIN : Result := opeInvoiceRefund;
       SOR : Result := opeOrderRefund;
    end; //case
  end;

begin
  Result := 0;
  // Create SRC
  FRefundSRC := NewOrderPaymentsSRC;

  //Set properties
  FRefundSRC.Account := FPaymentInfo.optTransaction.CustCode;
  FRefundSRC.Currency := FPaymentInfo.optTransaction.Currency;
  FRefundSRC.OriginalXRate := FPaymentInfo.optTransaction.CXRate[UseCoDayRate];
  FRefundSRC.ControlGL := FPaymentInfo.optTransaction.CtrlNom;
  FRefundSRC.PaymentValue := FPaymentTransaction.opphRefundValue * -1;
  FRefundSRC.OPElement := GetOrderPaymentElement(FPaymentInfo.optTransaction.InvDocHed);

  if FRefundSRC.OPElement = opeInvoiceRefund then
  begin
    //Refunding against invoice
    FRefundSRC.TransactionRef := FPaymentInfo.optTransaction.OurRef;
    FRefundSRC.OrderReference := FPaymentInfo.optTransaction.thOrderPaymentOrderRef;
    FRefundSRC.PaymentRef := FPaymentTransaction.opphPayment.OurRef;
  end
  else
  begin
    //Refunding against order - match against SRC
    FRefundSRC.TransactionRef := FPaymentTransaction.opphPayment.OurRef;
    FRefundSRC.OrderReference := FPaymentInfo.optTransaction.OurRef;
  end;

  //Get Bank GL & CC/Dept from original SRC line
  FRefundSRC.ExLocal := FPaymentInfo.ExLocal;
  with FRefundSRC.ExLocal^ do
  begin
      //Find the transaction line for the payment - created automatically so only one line per SRC
      KeyS := FullNomKey(FPaymentTransaction.opphPayment.FolioNum);

      Res := LFind_Rec(B_GetGEq, IDetailF, IdFolioK, KeyS);

      if (Res = 0) and (LId.FolioRef = FPaymentTransaction.opphPayment.FolioNum) then
      begin

          FRefundSRC.BankGL := LId.NomCode;
          fRefundSRC.CostCentre := LId.CCDep[True];
          FRefundSRC.Department := LId.CCDep[False];

      end // if (LId.FolioRef = FPaymentTransaction.opphPayment.FolioNum)
      else
        //Haven't found line for the payment we're refunding against
        Result := 999;

  end;

  //Store
  if Result = 0 then
    Result := FRefundSRC.Save;
end;

//-------------------------------------------------------------------------
//Creates the negative SRF
Function TOrderPaymentsRefundManager.CreateSRF : Integer;
var
  Res : Integer;
  KeyS : Str255;
begin
  Result := 0;
  // Create SRC
  FRefundSRF := NewOrderPaymentsSRF;

  //Set properties
  FRefundSRF.Account := FPaymentInfo.optTransaction.CustCode;
  FRefundSRF.Currency := FPaymentInfo.optTransaction.Currency;
  FRefundSRF.OriginalXRate := FPaymentInfo.optTransaction.CXRate[UseCoDayRate];
  FRefundSRF.ControlGL := FPaymentInfo.optTransaction.CtrlNom;
  FRefundSRF.PaymentValue := FPaymentTransaction.opphRefundValue;
  FRefundSRF.OPElement := opeInvoiceRefund;


  FRefundSRF.TransactionRef := FPaymentInfo.optTransaction.OurRef; //SIN
  FRefundSRF.OrderReference := FPaymentInfo.optTransaction.thOrderPaymentOrderRef; //SOR
  FRefundSRF.PaymentRef := FPaymentTransaction.opphPayment.OurRef; //SRC

  FRefundSRF.PaymentTransaction := FPaymentTransaction;

  FRefundSRF.SerialBatchList := FSerialBatchList;

  //Get Bank GL & CC/Dept from original SRC line(s)
  FRefundSRF.ExLocal := FPaymentInfo.ExLocal;
  with FRefundSRF.ExLocal^ do
  begin
      //Find the transaction line for the payment - created automatically so only one line per SRC
      KeyS := FullNomKey(FPaymentTransaction.opphPayment.FolioNum);

      Res := LFind_Rec(B_GetGEq, IDetailF, IdFolioK, KeyS);

      if (Res = 0) and (LId.FolioRef = FPaymentTransaction.opphPayment.FolioNum) then
      begin

          FRefundSRF.BankGL := LId.NomCode;
          FRefundSRF.CostCentre := LId.CCDep[True];
          FRefundSRF.Department := LId.CCDep[False];

      end // if (LId.FolioRef = FPaymentTransaction.opphPayment.FolioNum)
      else
        //Haven't found line for the payment we're refunding against
        Result := 999;

  end;


  //Store
  if Result = 0 then
    Result := FRefundSRF.Save;
end;


function TOrderPaymentsRefundManager.GetSerialNos: Boolean;
var
  i : integer;
  NeedAtLeastOne : Boolean;
 {$IFNDEF EXDLL}
  LineRec : TSerialLineRec;
  {$ENDIF}
begin
  Result := True;
 {$IFNDEF EXDLL}
  NeedAtLeastOne := False;
  //Iterate through order lines. If any of them are using serial/batch then create a  SerialNo form and add the line.
  for i := 0 to FPaymentTransaction.opphPaymentLineCount - 1 do
  begin
    LineRec.ID := FPaymentTransaction.opphPaymentLines[i].opplOrderLine.opolLine;
    LineRec.ID.Qty := FPaymentTransaction.opphPaymentLines[i].opplRefundQuantity;
    if not ZeroFloat(LineRec.ID.Qty) and WantSerialNos(LineRec.Id.StockCode) then
    begin
      if not NeedAtLeastOne then
      begin  //Create form
        SerialNoForm := TfrmSerialNos.Create(Application.MainForm);
        SerialNoForm.ExLocal := FExLocal;
        SerialNoForm.OurRef := FPaymentInfo.optTransaction.OurRef;
        SerialNoForm.SRCRef := FPaymentTransaction.opphPayment.OurRef;
        NeedAtLeastOne := True;
      end;
      LineRec.StockFolio := FExLocal.LStock.StockFolio; //We found the correct stock record in WantSerialNos
      SerialNoForm.AddLine(LineRec);
    end;
  end;

  if NeedAtLeastOne then
  begin
    SerialNoForm.ShowSerialNos;
    SerialNoForm.ShowModal;

    if SerialNoForm.ModalResult = mrOK then
    begin
      for i := 0 to SerialNoForm.FrameCount - 1 do
        ProcessSerialBatchFrame(SerialNoForm.Frames[i]);
    end
    else
      Result := False;
  end;
 {$ENDIF EXDLL}
end;

function TOrderPaymentsRefundManager.WantSerialNos(
  const StockCode: string): Boolean;
var
  Res : Integer;
  KeyS : Str255;
begin
 {$IFNDEF EXDLL}
  //Get stock record and see whether it uses serial/batch
  KeyS := FullStockCode(StockCode);

  Res := FExLocal.LFind_Rec(B_GetEq, StockF, StkCodeK, KeyS);

  if Res = 0 then
    with FExLocal^ do
      Result := (LStock.StkValType = 'R') Or ((LStock.StkValType = 'A') And (LStock.SerNoWAvg = 1))
  else
    Result := False;
  {$ELSE}
  //For Toolkit we leave the user to deal with serial batches
   Result := False;
  {$ENDIF}
end;

{$IFNDEF EXDLL}
procedure TOrderPaymentsRefundManager.ProcessSerialBatchFrame(
  const AFrame: TframeSerialNo);
var
  i : Integer;
  Details : TSerialBatchDetails;
  KeyS : string;
begin
  with AFrame.lvSerialNos do
  begin
    for i := 0 to Items.Count - 1 do
      if Items[i].Checked then
      begin
        Details := TSerialBatchDetails.Create;

        Details.StockCode := AFrame.StockCode;
        Details.LineNo := AFrame.LineNo;
        Details.BatchNo := Trim(Items[i].SubItems[0]);

        Details.RecordAddress := StrtoInt(Items[i].SubItems[COL_ADDRESS]);
        Details.Location := Trim(Items[i].SubItems[COL_LOCATION]);
        if Items[i].Caption = '' then
          Details.Qty := StrtoDouble(Items[i].SubItems[COL_QTY])
        else
          Details.Qty := 1;
        KeyS := Details.StockCode + IntToStr(Details.LineNo);
        FSerialBatchList.AddObject(KeyS, Details);
      end;
  end;
end;
{$ENDIF EXDLL}


procedure TOrderPaymentsRefundManager.UnlockSerialBatchRecords;
var
  i : Integer;
  Details : TSerialBatchDetails;
begin
  for i := 0 to FSerialBatchList.Count - 1 do
  begin
    Details := TSerialBatchDetails(FSerialBatchList.Objects[i]);

    FExLocal.UnLockMLock(MiscF, Details.RecordAddress);
  end;
end;

End.


