unit mainform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms
  , Dialogs, ComCtrls, StdCtrls, ComObj, Inifiles, Enterprise01_TLB, ExtCtrls
  , MathUtil;
  //, uMultiList;

type
  TfrmMainForm = class(TForm)
    lbPrompt: TLabel;
    pbProgressBar: TProgressBar;
    btnClose: TButton;
    lbProgress: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
    oToolkit : IToolkit;
    bAutoClose, bOnlyClearZeroBalance : boolean;

    {$IFDEF DEBUG}
    slDebug : TStringList;
    {$ENDIF}

    procedure DoMatch(const ssDocRef : ShortString; const ssPayRef : ShortString;
                      const dbInvValue : Double; const dbRecValue : Double );

  public
    { Public declarations }
  end;

var
  frmMainForm: TfrmMainForm;

implementation

uses
  PISecure, SecCodes;

{$R *.dfm}

procedure TfrmMainForm.FormCreate(Sender: TObject);
const
  sPlugInName = 'Exchequer Auto Settle Plug-In';
//  {$IFDEF EX600}
//    // CA 10/07/2013 v7.0.5  ABSEXCH-14439: Rebranding so version number updated
//    sVersionNo = 'v7.0.05.006';
////    sVersionNo = 'v6.20.005';
//  {$ELSE}
//    sVersionNo = 'v5.52.005';
//  {$ENDIF}

  // v6.20.004
  procedure ReadIniFileSettings;
  var
    sINIFilename : string;
    AutoSettINI : TINIFile;
  begin {ReadIniFileSettings}
    sINIFilename := IncludeTrailingPathDelimiter(ExtractFilePath(application.exename))
    + 'Settle.ini';
    AutoSettINI := TInifile.Create(sINIFilename);
    bOnlyClearZeroBalance := UpperCase(Trim(AutoSettINI.ReadString('Settle'
    , 'ZeroBalanceOnly', 'FALSE'))) = 'TRUE';
    AutoSettINI.Free;
  end; {ReadIniFileSettings}
var
  sMessage : string;

begin
  oToolkit := nil; // just to be sure, to be sure
  bAutoClose := TRUE;
  bOnlyClearZeroBalance := FALSE;

  //Check Plug-In Security
  if PICheckSecurity('EXCHAUTSET000014', 'fF5dsSke5D7 [Fr2', sPlugInName, '',
                     stSystemOnly, ptStandaloneEXE, ExtractFileName(Application.EXEName)) then
  begin
    bAutoClose := FALSE;

    // v6.20.004
    ReadIniFileSettings;

    {$IFDEF DEBUG}
    frmMainForm.Caption := 'DEBUG - ' + frmMainForm.Caption;
    {$ENDIF}

    if (MessageDlg('Please ensure that no other users are accessing Exchequer.'
    , mtInformation,[mbOK,mbCancel],0) = mrOK) then
    begin
//      if (MessageDlg('Run Sales Ledger Auto Settle Routine?',mtConfirmation,[mbYes,mbNo],0) = mrNo) then
      if bOnlyClearZeroBalance then sMessage := 'Run Sales Ledger Auto Settle Routine (Zero Balances Only) ?'
      else sMessage := 'Run Sales Ledger Auto Settle Routine ?';
      if (MessageDlg(sMessage, mtConfirmation, [mbYes,mbNo], 0) = mrNo) then
      begin
        bAutoClose := TRUE;
      end;{if}
    end
    else
    begin
      bAutoClose := TRUE;
    end;{if}
  end;{if}
end;

procedure TfrmMainForm.FormActivate(Sender: TObject);

  // v6.20.004
  function ZeroBalanceAccount(TheCustomer : IAccount) : boolean;
  var
    rBalance : real;
  begin{ZeroBalanceAccount}
    // get current Customer balance
    TheCustomer.acHistory.acCurrency := 0;
    TheCustomer.acHistory.acPeriod := 100 + oToolkit.SystemSetup.ssCurrentPeriod;
    TheCustomer.acHistory.acYear := 0;
    rBalance := (TheCustomer.acHistory.acBalance + TheCustomer.acHistory.acCommitted);
    Result := ZeroFloat(rBalance);
  end;{ZeroBalanceAccount}

type
  tCompareRes = ( RECEIPT_PART_PAY, ONE_FOR_ONE, RECEIPT_OVER_PAY );
  tDocType = ( RECEIPT_DOC, INVOICE_DOC, SETTLED_DOC );
var
  // for COM toolkit "backdoor"
  Code1, Code2, Code3: longint;

  Res : LongInt;
  CustRes, TransRes : LongInt;
//  MatchRes : LongInt;
  bMatchFound : Boolean;

  DocType : tDocType;

  wsCustSearchKey, wsSearchKey : WideString;
  ssReceiptRef, ssInvoiceRef : ShortString;

  ssCustomerRef : ShortString;
  slReceipts, slInvoices : TStringList;

  CompareRes : tCompareRes;
  // dbPayOffValue is a 'working' variable and as such it's name doesn't completely reflect it's useage
  dbPayOffValue,
  dbReceiptValue, dbInvoiceValue,
  dbReceiptRemainder, dbInvoiceRemainder : Double;

  dbReceiptNormal, dbReceiptAbs : Double;
  dbInvoiceNormal, dbInvoiceAbs : Double;

  dbAmountSettled, dbTotalValue, dbTotalOutstanding : Double;

  siDecPlaces : SmallInt;

begin
  if (not bAutoClose) then
  begin
    {$IFDEF DEBUG}
    slDebug := TStringList.Create;
    {$ENDIF}
    // create COM toolkit object
    oToolKit := CreateOLEObject ('Enterprise01.Toolkit') as IToolKit;
    if assigned(oToolKit) then
    begin
      with oToolKit do
      begin
        // for COM toolkit "backdoor"
        EncodeOpCode(97, Code1, Code2, Code3);
        Configuration.SetDebugMode(Code1, Code2, Code3);

        if Enterprise.enRunning then
          Configuration.DataDirectory := Enterprise.enCompanyPath;

        Res := OpenToolkit;
        if (Res = 0) then
        begin
          siDecPlaces := SystemSetup.ssSalesDecimals;

          wsCustSearchKey := Customer.BuildCodeIndex('A');
          CustRes := Customer.GetFirst;
          while (CustRes = 0) do
          begin
            // v6.20.004
            if (not bOnlyClearZeroBalance) or ZeroBalanceAccount(Customer) then
            begin

              slReceipts := TStringList.Create;
              slInvoices := TStringList.Create;

              ssCustomerRef := Customer.acCode;
              {$IFDEF DEBUG}
              slDebug.Add(' ');
              slDebug.Add('************************************');
              slDebug.Add('ssCustomerRef '+ssCustomerRef);
              {$ENDIF}
              lbProgress.Caption := trim(Customer.acCompany);
              pbProgressBar.Position := 0;

              Transaction.Index := thIdxAccount;
              wsSearchKey := Transaction.BuildAccountIndex(trim(ssCustomerRef));
              TransRes := Transaction.GetGreaterThanOrEqual(wsSearchKey);

              // NF: 22/03/2010 - ABSPLUG-88
              // Changes so it skips transactions it's not interested in, not totally aborts out of the loop!
//              while (TransRes = 0) and
//                    (oToolkit.Transaction.thDocType in [dtSIN, dtSRC, dtSCR, dtSJI, dtSJC, dtSRF, dtSRI]) and
//                    (oToolkit.Transaction.thAcCode = ssCustomerRef) do
              while (TransRes = 0)
              and (oToolkit.Transaction.thAcCode = ssCustomerRef) do
              begin
                if (oToolkit.Transaction.thDocType in [dtSIN, dtSRC, dtSCR, dtSJI, dtSJC, dtSRF, dtSRI]) then
                begin
                  pbProgressBar.StepIt;

                  dbTotalValue := Abs(oToolkit.Transaction.thTotals[TransTotInBase]); //  oToolkit.Transaction.thNetValue;
                  dbAmountSettled := Abs(oToolkit.Transaction.thTotals[TransTotSettledInBase]); // oToolkit.Transaction.thAmountSettled;
                  dbTotalOutstanding := oToolkit.Transaction.thTotals[TransTotOutstandingInBase];

                  if (dbTotalOutstanding > 0) then
                  begin
                    DocType := INVOICE_DOC;
                    {$IFDEF DEBUG}
                    slDebug.Add('OurRef ('+oToolkit.Transaction.thOurRef+')');
                    slDebug.Add('DocType = INVOICE_DOC');
                    slDebug.Add('dbTotalValue ('+FloatToStr(dbTotalValue)+')');
                    slDebug.Add('dbAmountSettled ('+FloatToStr(dbAmountSettled)+')');
                    slDebug.Add('dbTotalOutStanding ('+FloatToStr(dbTotalOutStanding)+')');
                    {$ENDIF}
                  end
                  else if (dbTotalOutstanding < 0) then
                  begin
                    DocType := RECEIPT_DOC;
                    {$IFDEF DEBUG}
                    slDebug.Add('OurRef ('+oToolkit.Transaction.thOurRef+')');
                    slDebug.Add('DocType = RECEIPT_DOC');
                    slDebug.Add('dbTotalValue ('+FloatToStr(dbTotalValue)+')');
                    slDebug.Add('dbAmountSettled ('+FloatToStr(dbAmountSettled)+')');
                    slDebug.Add('dbTotalOutStanding ('+FloatToStr(dbTotalOutStanding)+')');
                    {$ENDIF}
                  end
                  else
                  begin
                    DocType := SETTLED_DOC;
                    {$IFDEF DEBUG}
                    slDebug.Add('OurRef ('+oToolkit.Transaction.thOurRef+')');
                    slDebug.Add('DocType = SETTLED_DOC');
                    slDebug.Add('dbTotalValue ('+FloatToStr(dbTotalValue)+')');
                    slDebug.Add('dbAmountSettled ('+FloatToStr(dbAmountSettled)+')');
                    slDebug.Add('dbTotalOutStanding ('+FloatToStr(dbTotalOutStanding)+')');
                    {$ENDIF}
                  end;

                  if (dbAmountSettled = dbTotalValue) then
                    bMatchFound := TRUE
                  else
                    bMatchFound := FALSE;

                  if (not bMatchFound) then
                  begin
                    // v6.20.004
    //                if (oToolkit.Transaction.thDocType in [dtSRC, dtSCR, dtSJC]) then

    //                if (DocType = RECEIPT_DOC) then
    //                begin
    //                  slReceipts.Add(oToolkit.Transaction.thOurRef)
    //                end
    //                else
    //                begin
    //                  if (DocType = INVOICE_DOC)
    //                  then slInvoices.Add(oToolkit.Transaction.thOurRef);
    //                end;{if}
                    case DocType of
                      RECEIPT_DOC : slReceipts.Add(oToolkit.Transaction.thOurRef);
                      INVOICE_DOC : slInvoices.Add(oToolkit.Transaction.thOurRef);
                    end;{case}
                  end;{if}
                end;{if}

                Application.ProcessMessages;
                TransRes := Transaction.GetNext;
              end; // while (TransRes = 0) and ... do

              // should have two StrLst of docs here.
              // Don't want to do that matching unless we have both half of the match.
              dbReceiptValue := 0;
              dbInvoiceValue := 0;
              dbReceiptRemainder := 0;
              dbInvoiceRemainder := 0;
              CompareRes := ONE_FOR_ONE;

              // get first receipt and invoice pair.
              if (slReceipts.Count > 0) then
                ssReceiptRef := slReceipts.Strings[0];
              if (slInvoices.Count > 0) then
                ssInvoiceRef := slInvoices.Strings[0];

              // loop...
              while (slReceipts.Count > 0) and (slInvoices.Count > 0) do
              begin
                // look up the two transaction documents and...
                Transaction.Index := thIdxOurRef;
                if (dbReceiptRemainder = 0) then
                begin
                  wsSearchKey := Transaction.BuildOurRefIndex(trim(ssReceiptRef));
                  TransRes := Transaction.GetEqual(wsSearchKey);
                  if (TransRes = 0) then
                  begin
                    dbReceiptValue := Functions.entRound(Transaction.thTotals[TransTotInBase],siDecPlaces);
                    dbReceiptNormal := Transaction.thTotals[TransTotOutstandingInBase];
                    dbReceiptAbs := abs(dbReceiptNormal);
                    dbReceiptRemainder := Functions.entRound(dbReceiptAbs,siDecPlaces);
  //                  dbReceiptRemainder := Functions.entRound(abs(Transaction.thTotals[TransTotOutstandingInBase]),siDecPlaces);
                  end;
                end;

                if (dbInvoiceRemainder = 0) then
                begin
                  wsSearchKey := Transaction.BuildOurRefIndex(trim(ssInvoiceRef));
                  TransRes := Transaction.GetEqual(wsSearchKey);
                  if (TransRes = 0) then
                  begin
                    dbInvoiceValue := Functions.entRound(Transaction.thTotals[TransTotInBase],siDecPlaces);
                    dbInvoiceNormal := Transaction.thTotals[TransTotOutstandingInBase];
                    dbInvoiceAbs := abs(dbInvoiceNormal);
                    dbInvoiceRemainder := Functions.entRound(dbInvoiceAbs,siDecPlaces);
  //                  dbInvoiceRemainder := Functions.entRound(abs(Transaction.thTotals[TransTotOutstandingInBase]),siDecPlaces);
                  end;
                end;

                {$IFDEF DEBUG}
                slDebug.Add(' '); // make the resulting debug file easier to read.
                {$ENDIF}

                // ...compare receipt and invoice totals and set CompareRes value.
                // keep appropriate remainder value depending upon CompareRes value.
                if (dbReceiptRemainder = dbInvoiceRemainder) then
                begin
                  {$IFDEF DEBUG}
                  slDebug.Add('CompareRes := ONE_FOR_ONE');
                  slDebug.Add('ssReceiptRef ('+ssReceiptRef+') ssInvoiceRef('+ssInvoiceRef+')');
                  slDebug.Add('dbReceiptRemainder ('+FloatToStr(dbReceiptRemainder)+') dbInvoiceRemainder ('+FloatToStr(dbInvoiceRemainder)+')');
                  {$ENDIF}
                  CompareRes := ONE_FOR_ONE;
                  if (dbInvoiceRemainder > 0) and (dbReceiptRemainder > 0) then
                    DoMatch(ssInvoiceRef, ssReceiptRef, dbInvoiceRemainder, dbReceiptRemainder);
                  dbInvoiceRemainder := 0;
                  dbReceiptRemainder := 0;
                end
                else if (dbReceiptRemainder < dbInvoiceRemainder) then
                begin
                  {$IFDEF DEBUG}
                  slDebug.Add('CompareRes := RECEIPT_PART_PAY');
                  slDebug.Add('ssReceiptRef ('+ssReceiptRef+') ssInvoiceRef('+ssInvoiceRef+')');
                  slDebug.Add('dbReceiptRemainder ('+FloatToStr(dbReceiptRemainder)+') dbInvoiceRemainder ('+FloatToStr(dbInvoiceRemainder)+')');
                  {$ENDIF}
                  CompareRes := RECEIPT_PART_PAY;
                  dbPayOffValue := Functions.entRound(
                                              (dbInvoiceRemainder - (dbInvoiceRemainder - dbReceiptRemainder)),siDecPlaces);
                  DoMatch(ssInvoiceRef, ssReceiptRef, dbPayOffValue, dbReceiptRemainder);
                  dbReceiptRemainder := 0;
                  dbInvoiceRemainder := Functions.entRound((dbInvoiceRemainder - dbPayOffValue),siDecPlaces);
                end
                else if (dbReceiptRemainder > dbInvoiceRemainder) then
                begin
                  {$IFDEF DEBUG}
                  slDebug.Add('CompareRes := RECEIPT_OVER_PAY');
                  slDebug.Add('ssReceiptRef ('+ssReceiptRef+') ssInvoiceRef('+ssInvoiceRef+')');
                  slDebug.Add('dbReceiptRemainder ('+FloatToStr(dbReceiptRemainder)+') dbInvoiceRemainder ('+FloatToStr(dbInvoiceRemainder)+')');
                  {$ENDIF}
                  CompareRes := RECEIPT_OVER_PAY;
                  dbPayOffValue := Functions.entRound((dbReceiptValue - (dbReceiptValue - dbInvoiceRemainder)),siDecPlaces);
                  DoMatch(ssInvoiceRef, ssReceiptRef, dbInvoiceRemainder, dbPayOffValue);
                  dbInvoiceRemainder := 0;
                  dbReceiptRemainder := Functions.entRound((dbReceiptRemainder - dbPayOffValue),siDecPlaces);
                end;

                // get receipt and/or invoice depending upon CompareRes.
                case CompareRes of
                  ONE_FOR_ONE :
                    begin
                      slReceipts.Delete(slReceipts.IndexOf(ssReceiptRef));
                      slInvoices.Delete(slInvoices.IndexOf(ssInvoiceRef));
                      if (slReceipts.Count > 0) then
                        ssReceiptRef := slReceipts.Strings[0];
                      if (slInvoices.Count > 0) then
                        ssInvoiceRef := slInvoices.Strings[0];
                    end;
                  RECEIPT_PART_PAY :
                    begin
                      slReceipts.Delete(slReceipts.IndexOf(ssReceiptRef));
                      if (slReceipts.Count > 0) then
                        ssReceiptRef := slReceipts.Strings[0];
                    end;
                  RECEIPT_OVER_PAY :
                    begin
                      slInvoices.Delete(slInvoices.IndexOf(ssInvoiceRef));
                      if (slInvoices.Count > 0) then
                        ssInvoiceRef := slInvoices.Strings[0];
                    end;
                end; // case CompareRes of...

              end; // while (slReceipts.Count > 0) and (slReceipts.Count > 0) do
              // ...loop

              while (slReceipts.Count > 0) do
                slReceipts.Delete(0);
              slReceipts.Free;

              while (slInvoices.Count > 0) do
                slInvoices.Delete(0);
              slInvoices.Free;
            end;{if}

            // Get Next
            CustRes := Customer.GetNext;

          end; // while (CustRes = 0) do
        end; // if (Res = 0) then
      end; // with oToolKit do
    end; // if assigned(oToolKit) then

    pbProgressBar.Position := pbProgressBar.Max;
    btnClose.Visible := TRUE;
    btnClose.SetFocus;

  end // if (not AutoClose) then
  else
    Close;
end;

procedure TfrmMainForm.DoMatch(const ssDocRef : ShortString; const ssPayRef : ShortString;
                               const dbInvValue : Double; const dbRecValue : Double );
                               // dbInvValue and dbRecValue are both in base currency
const
  RateToBase = TRUE;
  BaseToRate = FALSE;
var
  wsSearchKey : WideString;
  oMatch : IMatching; 

  MatchRes, DocRefRes : LongInt;
  iInvoiceCurrency : Integer;
begin
// Initial match...
  with oToolkit do
  begin
    // Looking up the receipt
    Transaction.Index := thIdxOurRef;
    wsSearchKey := Transaction.BuildOurRefIndex(trim(ssPayRef));
    DocRefRes := Transaction.GetEqual(wsSearchKey);
    if (DocRefRes = 0) then
      iInvoiceCurrency := Transaction.thCurrency
    else
      iInvoiceCurrency := Configuration.DefaultCurrency;

    wsSearchKey := Transaction.BuildOurRefIndex(trim(ssDocRef));
    DocRefRes := Transaction.GetEqual(wsSearchKey);
    if (DocRefRes = 0) then
    begin
      oMatch := Transaction.thMatching.Add;
      if (assigned(oMatch)) then
      begin
        oMatch.maPayRef := ssPayRef;
        oMatch.maPayValue := Functions.entRound( dbRecValue, 2); // 0.00;
        oMatch.maPayValue := Functions.entRound( dbRecValue, 2);
        oMatch.maPayCurrency := iInvoiceCurrency; // Transaction.thCurrency;

        {$IFDEF DEBUG}
        slDebug.Add('oMatch.maPayRef ('+oMatch.maPayRef+')');
        slDebug.Add('oMatch.maPayValue ('+FloatToStr(oMatch.maPayValue)+')');
        slDebug.Add('oMatch.maPayCurrency ('+IntToStr(oMatch.maPayCurrency)+')');
        {$ENDIF}

//        oMatch.maBaseValue := Functions.entRound( dbInvValue, 2);
        oMatch.maBaseValue := Functions.entRound( dbInvValue, 2);

        {$IFDEF DEBUG}
        slDebug.Add('oMatch.maBaseValue ('+FloatToStr(oMatch.maBaseValue)+')');
        {$ENDIF}

        oMatch.maDocRef := ssDocRef;    // <--- invoice reference
//        oMatch.maDocValue := Functions.entRound( dbInvValue, 2);
        oMatch.maDocValue := Functions.entRound( dbInvValue, 2);
        oMatch.maDocCurrency := Transaction.thCurrency;

        {$IFDEF DEBUG}
        slDebug.Add('oMatch.maDocRef ('+oMatch.maDocRef+')');
        slDebug.Add('oMatch.maDocValue ('+FloatToStr(oMatch.maDocValue)+')');
        slDebug.Add('oMatch.maDocCurrency ('+IntToStr(oMatch.maDocCurrency)+')');
        {$ENDIF}

        MatchRes := oMatch.Save;
        if (MatchRes <> 0) then
        begin
//          ShowMessage('Unable to save match  - Error ('+QuotedStr(LastErrorString)+') occurred.');
          {$IFDEF DEBUG}
          slDebug.Add('Unable to save match  - Error ('+QuotedStr(LastErrorString)+') occurred.');
          {$ENDIF}
        end;
      end
      else
      begin
        oMatch := nil;
      end;
    end; // if (DocRefRes = 0) then
  end; // with oToolkit do
// ...Initial match
end;

procedure TfrmMainForm.FormClose(Sender: TObject;  var Action: TCloseAction);
begin
  if assigned(oToolkit) then
  begin
    oToolkit.CloseToolkit;
    oToolkit := nil;
  end;

  if (not bAutoClose) then
  begin
    {$IFDEF DEBUG}
    slDebug.SaveToFile('c:\settle.log');
    while (slDebug.Count > 0) do
      slDebug.Delete(0);
    slDebug.Free;
    {$ENDIF}
  end;

end;

procedure TfrmMainForm.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.
