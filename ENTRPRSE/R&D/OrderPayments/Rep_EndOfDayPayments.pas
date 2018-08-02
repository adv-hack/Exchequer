Unit Rep_EndOfDayPayments;

Interface

Uses Classes, SysUtils, Controls, Graphics, StrUtils, RpDefine, RpDevice,
     GlobVar, VarConst, SQLRep_BaseReport;

Type
  EndOfDayPaymentsReportIndexEnum = (idxReceiptOurRef=0, idxOrderOurRef=1, idxAccount=2, idxTransDate=3, idxReceiptType=4, idxCreditCardAuthNo=5);

Const
  EndOfDayPaymentsReportIndexDescriptions : Array [EndOfDayPaymentsReportIndexEnum] of String =
    (
      {idxReceiptOurRef}      'Receipt OurRef',
      {idxOrderOurRef}        'Order OurRef',
      {idxAccount}            'Account Code, Receipt OurRef',
      {idxTransDate}          'Transaction Date, Receipt OurRef',
      {idxReceiptType}        'Receipt Type, Receipt OurRef',
      {idxCreditCardAuthNo}   'Credit Card Authorisation Number'
    );

Type
  TEndOfDayPaymentsReport = Object(TSQLRep_BaseReport)
    procedure RepSetTabs; virtual;
    procedure RepPrintPageHeader; virtual;
    procedure RepPrint(Sender : TObject); virtual;
  Private
    FAccountCode : ShortString;
    FStartDate : LongDate;
    FEndDate : LongDate;
    FSortOrder : EndOfDayPaymentsReportIndexEnum;

    FRows : TStringList;

    Procedure SetAccountCode (Value : ShortString);

    // Called by the database specific descendants to add a transaction into the report
    procedure AddRow (Const Transaction : InvRec);
  Protected
    Procedure LoadData;  Virtual; Abstract;
  Public
    Property AccountCode : ShortString Read FAccountCode Write SetAccountCode;
    Property StartDate : LongDate Read FStartDate Write FStartDate;
    Property EndDate : LongDate Read FEndDate Write FEndDate;
    Property SortOrder : EndOfDayPaymentsReportIndexEnum Read FSortOrder Write FSortOrder;

    Constructor Create(AOwner  :  TObject);
    Destructor  Destroy; Virtual;

    function GetReportInput: Boolean; virtual;
    function SQLLoggingArea : string; virtual;
  End; // TEndOfDayPaymentsReport

  pEndOfDayPaymentsReport = ^TEndOfDayPaymentsReport;

  //------------------------------

  // Pervasive specific descendant with Pervasive specific data access routines
  TPervasiveEndOfDayPaymentsReport = Object(TEndOfDayPaymentsReport)
  Protected
    Procedure LoadData; Virtual;  // Object - so use Virtual and not Override
  Public
    Constructor Create(AOwner  :  TObject);
  End;

  //------------------------------

  // MS SQL specific descendant with SQL specific data access routines
  TSQLEndOfDayPaymentsReport = Object(TEndOfDayPaymentsReport)
  Protected
    Procedure LoadData; Virtual;  // Object - so use Virtual and not Override
  Public
    Constructor Create(AOwner  :  TObject);
  End;

  //------------------------------

// Construction method returns either the Pervasive or MS SQL version as appropriate
Function CreateEndOfDayPaymentsReport (Const Owner : TComponent) : pEndOfDayPaymentsReport;

Implementation

Uses ETDateU, ComnUnit, SQLUtils, SQLTransactions, BtrvU2, BTKeys1u,
     BTSupU1,              // GenRealMask
     SalTxl1U,             // FormatCurFloat
     oCreditCardGateway;   // Credit Card Interface

Type
  EndOfDayPaymentsReportRowTypeEnum = (rtPayment = 1, rtRefund=2);

Const
  EndOfDayPaymentsReportRowTypeSortValue : Array [EndOfDayPaymentsReportRowTypeEnum] of Char =
    (
      {rtPayment}  'P',
      {rtRefund}   'R'
    );
  EndOfDayPaymentsReportRowTypeDescriptions : Array [EndOfDayPaymentsReportRowTypeEnum] of String =
    (
      {rtPayment}  'Payment',
      {rtRefund}   'Refund'
    );

Type
  TEndOfDayPaymentsReportRow = Class(TObject)
  Private
    FSRCRef : String[10];
    FSORRef : String[10];
    FAccountCode : String[10];
    FTransDate : LongDate;
    FCreditCardAuthNo : String[20];
    FReceiptType : EndOfDayPaymentsReportRowTypeEnum;
    FReceiptValue : Double;
    FReceiptCurrency : Byte;

    Function GetReceiptRef : String;
    Function GetOrderRef : String;
    Function GetAccountCode : String;
    Function GetTransactionDate : LongDate;
    Function GetCreditCardAuthNo : String;
    Function GetTypeDescription : String;
    Function GetReceiptValue : Double;
    Function GetReceiptCurrency : Byte;

    Function GetIndexString (Index : EndOfDayPaymentsReportIndexEnum) : String;
  Public
    Property IndexString [Index : EndOfDayPaymentsReportIndexEnum] : String Read GetIndexString;

    Property ReceiptRef : String Read GetReceiptRef;
    Property OrderRef : String Read GetOrderRef;
    Property AccountCode : String Read GetAccountCode;
    Property TransactionDate : LongDate Read GetTransactionDate;
    Property CreditCardAuthNo : String Read GetCreditCardAuthNo;
    Property TypeDescription : String Read GetTypeDescription;
    Property ReceiptValue : Double Read GetReceiptValue;
    Property ReceiptCurrency : Byte Read GetReceiptCurrency;

    Constructor Create (Const Transaction : InvRec);
  End; // TEndOfDayPaymentsReportRow

//=========================================================================

// Construction method returns either the Pervasive or MS SQL version as appropriate
Function CreateEndOfDayPaymentsReport (Const Owner : TComponent) : pEndOfDayPaymentsReport;
Var
  oPSQL : ^TPervasiveEndOfDayPaymentsReport;
  oSQL : ^TSQLEndOfDayPaymentsReport;
Begin // CreateEndOfDayPaymentsReport
  If SQLUtils.UsingSQL Then
  Begin
    New(oSQL, Create(Owner));
    Result := oSQL;
  End // If SQLUtils.UsingSQL
  Else
  Begin
    New(oPSQL, Create(Owner));
    Result := oPSQL;
  End // Else
End; // CreateEndOfDayPaymentsReport

//=========================================================================

Constructor TEndOfDayPaymentsReportRow.Create (Const Transaction : InvRec);
Begin // Create
  Inherited Create;

  // Store the column value in the object - uses less memory than storing the entire transaction
  FSRCRef := Transaction.OurRef;
  FSORRef := Transaction.thOrderPaymentOrderRef;
  FAccountCode := Transaction.CustCode;
  FTransDate := Transaction.TransDate;
  FCreditCardAuthNo := Transaction.thCreditCardAuthorisationNo;
  If (Transaction.thOrderPaymentElement In OrderPayment_PaymentSet) Then
    FReceiptType := rtPayment
  Else
    FReceiptType := rtRefund;
  FReceiptValue := ITotal(Transaction) * DocCnst[Transaction.InvDocHed] * DocNotCnst;
  FReceiptCurrency := Transaction.Currency;
End; // Create

//-------------------------------------------------------------------------

Function TEndOfDayPaymentsReportRow.GetIndexString (Index : EndOfDayPaymentsReportIndexEnum) : String;

  //------------------------------

  Function FormatString(Const TheString : String; Const ToLength : Integer) : String;
  Begin // FormatString
    Result := Copy (TheString + StringOfChar(' ', ToLength), 1, ToLength);
  End; // FormatString

  //------------------------------

Begin // GetIndexString
  Case Index Of
    idxReceiptOurRef    : Result := FormatString(FSRCRef, 10);
    idxOrderOurRef      : Result := FormatString(FSORRef, 10);
    idxAccount          : Result := FormatString(FAccountCode, 10) + FormatString(FSRCRef, 10);
    idxTransDate        : Result := FormatString(FTransDate, 8) + FormatString(FSRCRef, 10);
    idxReceiptType      : Result := EndOfDayPaymentsReportRowTypeSortValue[FReceiptType] + FormatString(FSRCRef, 10);
    idxCreditCardAuthNo : Result := FormatString(FCreditCardAuthNo, 20);
  Else
    Raise Exception.Create('TEndOfDayPaymentsReportRow.GetIndexString: Unknown Index (' + IntToStr(Ord(Index)) + ')');
  End; // Case Index
End; // GetIndexString

//-------------------------------------------------------------------------

Function TEndOfDayPaymentsReportRow.GetReceiptRef : String;
Begin // GetReceiptRef
  Result := FSRCRef
End; // GetReceiptRef

//------------------------------

Function TEndOfDayPaymentsReportRow.GetOrderRef : String;
Begin // GetOrderRef
  Result := FSORRef
End; // GetOrderRef

//------------------------------

Function TEndOfDayPaymentsReportRow.GetAccountCode : String;
Begin // GetAccountCode
  Result := FAccountCode
End; // GetAccountCode

//------------------------------

Function TEndOfDayPaymentsReportRow.GetTransactionDate : LongDate;
Begin // GetTransactionDate
  Result := FTransDate
End; // GetTransactionDate

//------------------------------

Function TEndOfDayPaymentsReportRow.GetCreditCardAuthNo : String;
Begin // GetCreditCardAuthNo
  Result := FCreditCardAuthNo
End; // GetCreditCardAuthNo

//------------------------------

Function TEndOfDayPaymentsReportRow.GetTypeDescription : String;
Begin // GetTypeDescription
  Result := EndOfDayPaymentsReportRowTypeDescriptions[FReceiptType]
End; // GetTypeDescription

//------------------------------

Function TEndOfDayPaymentsReportRow.GetReceiptValue : Double;
Begin // GetReceiptValue
  Result := FReceiptValue
End; // GetReceiptValue

//------------------------------

Function TEndOfDayPaymentsReportRow.GetReceiptCurrency : Byte;
Begin // GetReceiptCurrency
  Result := FReceiptCurrency
End; // GetReceiptCurrency

//=========================================================================

Constructor TEndOfDayPaymentsReport.Create(AOwner  :  TObject);
Begin // Create
  Inherited Create(AOwner);

  // Use a stringlist to store the row data as it is read in by the database
  // specific descendants, the string/sorting functionality can be used to sort
  // the rows into the desired order for printing
  FRows := TStringList.Create;
  // Don't sort until the list is loaded though for performance reasons
  FRows.Sorted := False;

  // Initialise parameter values
  FAccountCode := '';
  FStartDate := '';
  FEndDate := '';
  FSortOrder := idxReceiptOurRef;
End; // Create

//------------------------------

Destructor TEndOfDayPaymentsReport.Destroy;
Var
  oReportRow : TObject;
Begin // Destroy
  // Destroy any row objects within the rows list
  While (FRows.Count > 0) Do
  Begin
    oReportRow := FRows.Objects[0];
    oReportRow.Free;
    FRows.Delete(0);
  End; // While (FRows.Count > 0)

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

function TEndOfDayPaymentsReport.GetReportInput: Boolean;
Begin // GetReportInput
  // Appears to be title shown in thread controller only
  ThTitle := 'End of Day Payments Report';

  // RepTitle appears to be show in the Thread Controller progress
  RepTitle := ThTitle + ' - ' + POutDate(FStartDate) + ' to ' + POutDate(FEndDate);
  If (Trim(FAccountCode) <> '') then
    RepTitle := RepTitle + ' - ' + Trim(FAccountCode);

  // Page title?
  PageTitle := RepTitle;

  RFont.Size := 7;
  ROrient := RPDefine.PoPortrait;

  Result := True;
End; // GetReportInput

//-------------------------------------------------------------------------

function TEndOfDayPaymentsReport.SQLLoggingArea : string;
Begin // SQLLoggingArea
  Result := 'EndOfDayPaymentsReport';
End; // SQLLoggingArea

//-------------------------------------------------------------------------

procedure TEndOfDayPaymentsReport.RepSetTabs;
Begin // RepSetTabs
  With RepFiler1 do
  Begin
    SetTab (MarginLeft, pjLeft,  20, 4, 0, 0);  // SRC Ref
    SetTab (NA,         pjLeft,  20, 4, 0, 0);  // SOR Ref
    SetTab (NA,         pjLeft,  15, 4, 0, 0);  // A/C Code
    SetTab (NA,         pjLeft,  18, 4, 0, 0);  // Date
    SetTab (NA,         pjLeft,  15, 4, 0, 0);  // Type - 'Payment'/'Refund'
    SetTab (NA,         pjRight, 29, 4, 0, 0);  // Amount
    SetTab (NA,         pjLeft,  40, 4, 0, 0);  // CC Auth Number
  end;
  SetTabCount;
End; // RepSetTabs

//-------------------------------------------------------------------------

procedure TEndOfDayPaymentsReport.RepPrintPageHeader;
Var
  CCTitle : String;
Begin // RepPrintPageHeader
  // Set up and print the column headers
  With RepFiler1 Do
  Begin
    // Only print the CC Authorisation Number column header if Credit Card support is enabled
    CCTitle := IfThen(CreditCardPaymentGateway.ccpgCompanyEnabled, 'CC Auth Number', '');

    DefFont(0, [fsBold]);
    SendLine(ConCat(#9, 'SRC Ref',
                    #9, 'SOR Ref',
                    #9, 'A/C Code',
                    #9, 'Date',
                    #9, 'Type',
                    #9, 'Amount',
                    #9, CCTitle));
    DefFont(0,[]);

    SetPen(clBlack,psSolid,-2,pmCopy);
    MoveTo(1,YD2U(CursorYPos)-4.3);
    LineTo((PageWidth-1-MarginRight),YD2U(CursorYPos)-4.3);
    MoveTo(1,YD2U(CursorYPos));
  End; // With RepFiler1
End; // RepPrintPageHeader

//-------------------------------------------------------------------------

procedure TEndOfDayPaymentsReport.RepPrint(Sender : TObject);
Var
  oCurrentRow : TEndOfDayPaymentsReportRow;
  I, iProgress : Integer;
Begin // RepPrint
  oReportLogger.StartReport;

  // Call the database specific descendants to load the data into the stringlist for the report
  LoadData;

  // Sort the rows into the order for printing
  FRows.Sorted := True;

  // Set total number of rows being printed
  ICount := FRows.Count;

  // Update progress - set to 50%
  iProgress := FRows.Count;
  InitProgress(iProgress * 2);
  UpDateProgress(iProgress);

  // Print the Report
  For I := 0 To (FRows.Count - 1) Do
  Begin
    // Extract the row object from the list
    oCurrentRow := TEndOfDayPaymentsReportRow(FRows.Objects[I]);

    // Check got room on the page
    ThrowNewPage(5);

    // Set up the drilldowns for the Transaction and the Customer/Supplier
    SendRepDrillDown(1, 1,       1, FullOurRefKey(oCurrentRow.ReceiptRef), InvF, InvOurRefK, 0);
    SendRepDrillDown(2, 2,       1, FullOurRefKey(oCurrentRow.OrderRef), InvF, InvOurRefK, 0);
    SendRepDrillDown(3, 3,       2, FullCustCode(oCurrentRow.AccountCode), CustF, CustCodeK, 0);
    SendRepDrillDown(4, TotTabs, 1, FullOurRefKey(oCurrentRow.ReceiptRef), InvF, InvOurRefK, 0);

    SendLine(ConCat(#9, oCurrentRow.ReceiptRef,
                    #9, oCurrentRow.OrderRef,
                    #9, oCurrentRow.AccountCode,
                    #9, POutDate(oCurrentRow.TransactionDate),
                    #9, oCurrentRow.TypeDescription,
                    #9, FormatCurFloat(GenRealMask, oCurrentRow.ReceiptValue, BOff, oCurrentRow.ReceiptCurrency),
                    #9, oCurrentRow.CreditCardAuthNo));


    // Update the line count and progress
    iProgress := iProgress + 1;
    if Assigned(ThreadRec) then
      UpDateProgress(iProgress);
  End; // For I

  // Print footer
  PrintEndPage;

  // Set progress to 100%
  UpDateProgress(FRows.Count * 2);

  oReportLogger.FinishReport;
End; // RepPrint

//-------------------------------------------------------------------------

// Called by the database specific descendants to add a transaction into the report
procedure TEndOfDayPaymentsReport.AddRow (Const Transaction : InvRec);
Var
  oReportRow : TEndOfDayPaymentsReportRow;
Begin // AddRow
  // Add the transaction into the list of rows
  oReportRow := TEndOfDayPaymentsReportRow.Create(Transaction);
  FRows.AddObject(oReportRow.IndexString[FSortOrder], oReportRow);
End; // AddRow

//-------------------------------------------------------------------------

Procedure TEndOfDayPaymentsReport.SetAccountCode (Value : ShortString);
Begin // SetAccountCode
  If (Trim(Value) <> '') Then
    FAccountCode := FullCustCode(Value)
  Else
    FAccountCode := '';
End; // SetAccountCode

//=========================================================================

Constructor TPervasiveEndOfDayPaymentsReport.Create(AOwner  :  TObject);
Begin // Create
  Inherited Create(AOwner);
  bIsSQLReport := False;
End; // Create

//------------------------------

Procedure TPervasiveEndOfDayPaymentsReport.LoadData;
Var
  sKey : Str255;
  iStatus, iProgress : Integer;
Begin // LoadData
  // Initialise progress to the number of transactions in Document.Dat - nothing else we can do
  iProgress := 0;
  InitProgress(Used_RecsCId(MTExLocal^.LocalF^[InvF], InvF, MTExLocal^.ExCLientId));
  UpDateProgress(iProgress);

  // Run through the transactions for the specified date range and add the Order Payments Receipts
  // into the list for printing 
  sKey := FStartDate;
  iStatus := MTExLocal^.LFind_Rec(B_GetGEq, InvF, InvDateK, sKey);

  While (iStatus = 0) And (MTExLocal^.LInv.TransDate >= FStartDate) And (MTExLocal^.LInv.TransDate <= FEndDate) Do
  Begin
    If (MTExLocal^.LInv.thOrderPaymentElement In OrderPayment_PaymentAndRefundSet) And
       (
         // Check the optional account code filter
         (FAccountCode = '')
         Or
         (MTExLocal^.LInv.CustCode = FAccountCode)
       ) Then
      // Add it into the list for printing
      AddRow (MTExLocal^.LInv);

    Inc(iProgress);
    UpDateProgress(iProgress);

    iStatus := MTExLocal^.LFind_Rec(B_GetNext, InvF, InvDateK, sKey)
  End; // While (iStatus = 0) And (MTExLocal^.LInv.TransDate >= FStartDate) And (MTExLocal^.LInv.TransDate <= FEndDate)
End; // LoadData

//=========================================================================

Constructor TSQLEndOfDayPaymentsReport.Create(AOwner  :  TObject);
Begin // Create
  Inherited Create(AOwner);
  bIsSQLReport := True;
End; // Create

//------------------------------

Procedure TSQLEndOfDayPaymentsReport.LoadData;
Var
  Headers: TSQLSelectTransactions;
  iProgress : Integer;
Begin // LoadData
  Headers := TSQLSelectTransactions.Create;
  Try
    Headers.CompanyCode := GetCompanyCode(SetDrive);
    Headers.FromClause  := 'FROM [COMPANY].DOCUMENT';

    // Limit the data coming back as far as possible - too complex to check the outstanding value in the query
    Headers.WhereClause := 'WHERE (thTransDate >= ' + QuotedStr(FStartDate) + ') And (thTransDate <= ' + QuotedStr(FEndDate) + ') ' +
                             'And (thOrderPaymentElement In (' + IntToStr(Ord(opeOrderPayment)) + ', ' +
                                                                 IntToStr(Ord(opeDeliveryPayment)) + ', ' +
                                                                 IntToStr(Ord(opeInvoicePayment)) + ', ' +
                                                                 IntToStr(Ord(opeOrderRefund)) + ', ' +
                                                                 IntToStr(Ord(opeInvoiceRefund)) + '))';
    If (Trim(FAccountCode) <> '') Then
      Headers.WhereClause := Headers.WhereClause + 'And (thAcCodeComputed = ' + QuotedStr(Trim(FAccountCode)) + ')';

    // Access using SQL navigation
    Headers.OpenFile;
    Headers.First;

    If (Headers.Count > 0) Then
    Begin
      // Initialise progress
      iProgress := 0;
      InitProgress(Headers.Count * 2);
      UpDateProgress(iProgress);

      While (Not Headers.Eof) Do
      Begin
        // Pass to common ancestor for processing
        AddRow (Headers.ReadRecord);

        Inc(iProgress);
        UpDateProgress(iProgress);

        Headers.Next;
      End; // While (Not Headers.Eof)
    End; // If (Headers.Count > 0)
  Finally
    Headers.Free;
  End; // Try..Finally
End; // LoadData

//=========================================================================

End.


