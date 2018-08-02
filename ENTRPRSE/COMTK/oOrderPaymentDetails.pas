unit oOrderPaymentDetails;

{ markd6 15:34 01/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, ComObj, ActiveX,
     {$IFNDEF WANTEXE}Enterprise01_TLB{$ELSE}Enterprise04_TLB{$ENDIF},
     oOPVATPayBtrieveFile, SQLCallerU, ExceptIntf;

type
  TTransactionOrderPaymentDetails = class(TAutoIntfObjectEx, ITransactionOrderPaymentDetails)
  private
    FPaymentDetails : OrderPaymentsVATPayDetailsRecType;
  protected
    // ITransactionOrderPaymentDetails
    function Get_opOrderRef: WideString; safecall;
    function Get_opReceiptRef: WideString; safecall;
    function Get_opTransRef: WideString; safecall;
    function Get_opLineOrderNo: Integer; safecall;
    function Get_opSORABSLineNo: Integer; safecall;
    function Get_opType: TOrderPaymentDetailsType; safecall;
    function Get_opCurrency: Integer; safecall;
    function Get_opDescription: WideString; safecall;
    function Get_opVATCode: WideString; safecall;
    function Get_opGoodsValue: Double; safecall;
    function Get_opVATValue: Double; safecall;
    function Get_opUserName: WideString; safecall;
    function Get_opDateCreated: WideString; safecall;
    function Get_opTimeCreated: WideString; safecall;
  public
    Constructor Create (Const PaymentDetails : OrderPaymentsVATPayDetailsRecType);
  End; { TTransactionOrderPaymentDetails }

  //-------------------------------------------------------------------------

  TTransactionOrderPaymentDetailsList = class(TAutoIntfObjectEx, ITransactionOrderPaymentDetailsList)
  Private
    FCurrentSORRef : ShortString;
    FPaymentDetails : TinterfaceList;
    OrderPaymentsBtrieveFile : TOrderPaymentsVATPayDetailsBtrieveFile;

    SQLCaller : TSQLCaller;
    sCompanyCode : ANSIString;

    Procedure LoadPervasiveDetails;
    Procedure LoadMSSQLDetails;

    // ITransactionOrderPaymentDetailsList
    function Get_opdlCount: Integer; safecall;
    function Get_opdlPaymentDetails(Index: Integer): ITransactionOrderPaymentDetails; safecall;
  Public
    Constructor Create;
    Destructor Destroy; override;

    Procedure SetStartKey (Const DocRef : ShortString);
  End; // TTransactionOrderPaymentDetailsList

  //------------------------------

Function CreateTTransactionOrderPaymentDetails : TTransactionOrderPaymentDetailsList;

implementation

uses ComServ, DB, DllErrU, GlobVar, SQLUtils, ADOConnect;

{-------------------------------------------------------------------------------------------------}

Function CreateTTransactionOrderPaymentDetails : TTransactionOrderPaymentDetailsList;
Begin { CreateTTransactionOrderPaymentDetails }
  Result := TTransactionOrderPaymentDetailsList.Create;
End; { CreateTTransactionOrderPaymentDetails }

{-------------------------------------------------------------------------------------------------}

Constructor TTransactionOrderPaymentDetails.Create (Const PaymentDetails : OrderPaymentsVATPayDetailsRecType);
Begin // Create
  Inherited Create (ComServer.TypeLib, ITransactionOrderPaymentDetails);
  FPaymentDetails := PaymentDetails;
End; // Create

//------------------------------

function TTransactionOrderPaymentDetails.Get_opOrderRef: WideString;
Begin // Get_opOrderRef
  Result := FPaymentDetails.vpOrderRef;
End; // Get_opOrderRef

//--------------------------

function TTransactionOrderPaymentDetails.Get_opReceiptRef: WideString;
Begin // Get_opReceiptRef
  Result := FPaymentDetails.vpReceiptRef;
End; // Get_opReceiptRef

//--------------------------

function TTransactionOrderPaymentDetails.Get_opTransRef: WideString;
Begin // Get_opTransRef
  Result := FPaymentDetails.vpTransRef;
End; // Get_opTransRef

//--------------------------

function TTransactionOrderPaymentDetails.Get_opLineOrderNo: Integer;
Begin // Get_opLineOrderNo
  Result := FPaymentDetails.vpLineOrderNo;
End; // Get_opLineOrderNo

//--------------------------

function TTransactionOrderPaymentDetails.Get_opSORABSLineNo: Integer;
Begin // Get_opSORABSLineNo
  Result := FPaymentDetails.vpSORABSLineNo;
End; // Get_opSORABSLineNo

//--------------------------

function TTransactionOrderPaymentDetails.Get_opType: TOrderPaymentDetailsType;
Begin // Get_opType
  // NOTE: Currently there is a direct mapping between enumOrderPaymentsVATPayDetailsType and TOrderPaymentDetailsType
  Result := TOrderPaymentDetailsType(FPaymentDetails.vpType);
End; // Get_opType

//--------------------------

function TTransactionOrderPaymentDetails.Get_opCurrency: Integer;
Begin // Get_opCurrency
  Result := FPaymentDetails.vpCurrency;
End; // Get_opCurrency

//--------------------------

function TTransactionOrderPaymentDetails.Get_opDescription: WideString;
Begin // Get_opDescription
  Result := FPaymentDetails.vpDescription;
End; // Get_opDescription

//--------------------------

function TTransactionOrderPaymentDetails.Get_opVATCode: WideString;
Begin // Get_opVATCode
  Result := FPaymentDetails.vpVATCode;
End; // Get_opVATCode

//--------------------------

function TTransactionOrderPaymentDetails.Get_opGoodsValue: Double;
Begin // Get_opGoodsValue
  Result := FPaymentDetails.vpGoodsValue;
End; // Get_opGoodsValue

//--------------------------

function TTransactionOrderPaymentDetails.Get_opVATValue: Double;
Begin // Get_opVATValue
  Result := FPaymentDetails.vpVATValue;
End; // Get_opVATValue

//--------------------------

function TTransactionOrderPaymentDetails.Get_opUserName: WideString;
Begin // Get_opUserName
  Result := FPaymentDetails.vpUserName;
End; // Get_opUserName

//--------------------------

function TTransactionOrderPaymentDetails.Get_opDateCreated: WideString;
Begin // Get_opDateCreated
  Result := FPaymentDetails.vpDateCreated;
End; // Get_opDateCreated

//--------------------------

function TTransactionOrderPaymentDetails.Get_opTimeCreated: WideString;
Begin // Get_opTimeCreated
  Result := FPaymentDetails.vpTimeCreated;
End; // Get_opTimeCreated

//=========================================================================

Constructor TTransactionOrderPaymentDetailsList.Create;
Begin // Create
  Inherited Create (ComServer.TypeLib, ITransactionOrderPaymentDetailsList);

  FPaymentDetails := TInterfaceList.Create;

  FCurrentSORRef := #0;

  OrderPaymentsBtrieveFile := NIL;
  SQLCaller := NIL;
End; // Create

Destructor TTransactionOrderPaymentDetailsList.Destroy;
Begin // Destroy
  FreeAndNIL(FPaymentDetails);

  If Assigned(OrderPaymentsBtrieveFile) Then
    FreeAndNIL(OrderPaymentsBtrieveFile);

  If Assigned(SQLCaller) Then
    SQLCaller.Free;

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Procedure TTransactionOrderPaymentDetailsList.SetStartKey (Const DocRef : ShortString);
Begin // SetStartKey
  If (FCurrentSORRef <> DocRef) Then
  Begin
    // Update current transaction ref
    FCurrentSORRef := DocRef;

    // Remove any pre-existing entries
    FPaymentDetails.Clear;

    // Load OPVATPay details and add into FPaymentDetails list
    If SQLUtils.UsingSQL Then
      LoadMSSQLDetails
    Else
      LoadPervasiveDetails;
  End; // If (FCurrentSORRef <> DocRef)
End; // SetStartKey

//------------------------------

Procedure TTransactionOrderPaymentDetailsList.LoadPervasiveDetails;
Var
  sKey : Str255;
  iStatus : Integer;
Begin // LoadPervasive
  If (Not Assigned(OrderPaymentsBtrieveFile)) Then
  Begin
    OrderPaymentsBtrieveFile := TOrderPaymentsVATPayDetailsBtrieveFile.Create;
    OrderPaymentsBtrieveFile.OpenFile (SetDrive + OrderPaymentsVATPayDetailsFilePath);
    OrderPaymentsBtrieveFile.Index := vpIdxReceiptRef;
  End; // If (Not Assigned(OrderPaymentsBtrieveFile))

  sKey := OrderPaymentsBtrieveFile.BuildReceiptRefKey (FCurrentSORRef);
  iStatus := OrderPaymentsBtrieveFile.GetGreaterThanOrEqual(sKey);
  While (iStatus = 0) And (OrderPaymentsBtrieveFile.VATPayDetails.vpOrderRef = sKey) Do
  Begin
    FPaymentDetails.Add(TTransactionOrderPaymentDetails.Create(OrderPaymentsBtrieveFile.VATPayDetails));
    iStatus := OrderPaymentsBtrieveFile.GetNext;
  End; // While (iStatus = 0) And (OrderPaymentsBtrieveFile.VATPayDetails.vpOrderRef = sKey)
End; // LoadPervasive

//------------------------------

Procedure TTransactionOrderPaymentDetailsList.LoadMSSQLDetails;
Var
  fldOrderRef, fldReceiptRef, fldTransRef, fldDescription,
  fldVATCode, fldUserName, fldDateCreated, fldTimeCreated : TStringField;
  fldLineOrderNo, fldSORABSLineNo, fldType, fldCurrency : TIntegerField;
  fldGoodsValue, fldVATValue : TFloatField;
  sQuery, sConnection : AnsiString;
  PayDetsRec : OrderPaymentsVATPayDetailsRecType;
Begin // LoadMSSQLDetails
  If (Not Assigned(SQLCaller)) Then
  Begin
    //RB 22/08/2017 2017-R2 ABSEXCH-18933: Fix SQL connection failure issue in Toolkits
    //Use GlobalAdoConnection
    SQLCaller := TSQLCaller.Create(GlobalAdoConnection);
    sCompanyCode := SQLUtils.GetCompanyCode(SetDrive);
  End; // If (Not Assigned(SQLCaller))

  sQuery := 'Select vpOrderRef, vpReceiptRef, vpTransRef, vpLineOrderNo, vpSORABSLineNo, ' +
                   'vpType, vpCurrency, vpDescription, vpVATCode, vpGoodsValue, ' +
                   'vpVATValue, vpUserName, vpDateCreated, vpTimeCreated ' +
              'From [COMPANY].OPVATPay ' +
             'Where (vpOrderRef=' + QuotedStr(FCurrentSORRef) + ') ' +
             'Order By vpOrderRef, vpReceiptRef, vpLineOrderNo, vpDateCreated, vpTimeCreated';
  SQLCaller.Select(sQuery, sCompanyCode);
  If (SQLCaller.ErrorMsg = '') Then
  Begin
    If (sqlCaller.Records.RecordCount > 0) Then
    Begin
      // Disable the link to the UI to improve performance when iterating through the dataset
      sqlCaller.Records.DisableControls;
      Try
        // Prepare fields
        fldOrderRef := sqlCaller.Records.FieldByName('vpOrderRef') As TStringField;
        fldReceiptRef := sqlCaller.Records.FieldByName('vpReceiptRef') As TStringField;
        fldTransRef := sqlCaller.Records.FieldByName('vpTransRef') As TStringField;
        fldLineOrderNo := sqlCaller.Records.FieldByName('vpLineOrderNo') As TIntegerField;
        fldSORABSLineNo := sqlCaller.Records.FieldByName('vpSORABSLineNo') As TIntegerField;
        fldType := sqlCaller.Records.FieldByName('vpType') As TIntegerField;
        fldCurrency := sqlCaller.Records.FieldByName('vpCurrency') As TIntegerField;
        fldDescription := sqlCaller.Records.FieldByName('vpDescription') As TStringField;
        fldVATCode := sqlCaller.Records.FieldByName('vpVATCode') As TStringField;
        fldGoodsValue := sqlCaller.Records.FieldByName('vpGoodsValue') As TFloatField;
        fldVATValue := sqlCaller.Records.FieldByName('vpVATValue') As TFloatField;
        fldUserName := sqlCaller.Records.FieldByName('vpUserName') As TStringField;
        fldDateCreated := sqlCaller.Records.FieldByName('vpDateCreated') As TStringField;
        fldTimeCreated := sqlCaller.Records.FieldByName('vpTimeCreated') As TStringField;

        sqlCaller.Records.First;
        While (Not sqlCaller.Records.EOF)  Do
        Begin
          FillChar(PayDetsRec, SizeOf(PayDetsRec), #0);
          PayDetsRec.vpOrderRef     := fldOrderRef.Value;
          PayDetsRec.vpReceiptRef   := fldReceiptRef.Value;
          PayDetsRec.vpTransRef     := fldTransRef.Value;
          PayDetsRec.vpLineOrderNo  := fldLineOrderNo.Value;
          PayDetsRec.vpSORABSLineNo := fldSORABSLineNo.Value;
          PayDetsRec.vpType         := enumOrderPaymentsVATPayDetailsType(fldType.Value);
          PayDetsRec.vpCurrency     := fldCurrency.Value;
          PayDetsRec.vpDescription  := fldDescription.Value;
          PayDetsRec.vpVATCode      := (fldVATCode.Value + #0)[1];
          PayDetsRec.vpGoodsValue   := fldGoodsValue.Value;
          PayDetsRec.vpVATValue     := fldVATValue.Value;
          PayDetsRec.vpUserName     := fldUserName.Value;
          PayDetsRec.vpDateCreated  := fldDateCreated.Value;
          PayDetsRec.vpTimeCreated  := fldTimeCreated.Value;
          FPaymentDetails.Add(TTransactionOrderPaymentDetails.Create(PayDetsRec));

          sqlCaller.Records.Next;
        End; // While (Not sqlCaller.Records.EOF) And (Status = 0) And KeepRun
      Finally
        sqlCaller.Records.EnableControls;
      End; // Try..Finally
    End; // If (sqlCaller.Records.RecordCount > 0)
  End; // If (SQLCaller.ErrorMsg = '')
  sqlCaller.Close;
End; // LoadMSSQLDetails

//-------------------------------------------------------------------------

function TTransactionOrderPaymentDetailsList.Get_opdlCount: Integer;
Begin // Get_opdlCount
  Result := FPaymentDetails.Count
End; // Get_opdlCount

//------------------------------

function TTransactionOrderPaymentDetailsList.Get_opdlPaymentDetails(Index: Integer): ITransactionOrderPaymentDetails;
Begin // Get_opdlPaymentDetails
  If (Index >= 1) And (Index <= FPaymentDetails.Count) Then
    Result := FPaymentDetails.Items[Index - 1] As ITransactionOrderPaymentDetails
  Else
    Raise ERangeError.Create ('opdlPaymentDetails: Invalid Index (' + IntToStr(Index) + '/' + IntToStr(FPaymentDetails.Count) + ')');
End; // Get_opdlPaymentDetails

//=========================================================================


end.