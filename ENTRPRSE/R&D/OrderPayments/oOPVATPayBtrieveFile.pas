Unit oOPVATPayBtrieveFile;

Interface

{$Align 1}

Uses GlobVar,         // Global Types / Variables
     VarConst,        // Global Types / Variables
     BtrvU2,          // Btrieve Interface
     oBtrieveFile;    // Btrieve Data Access Object

Const
  OrderPaymentsVATPayDetailsFilePath = 'Trans\OPVATPay.Dat';

Type
  // Idx 0: vpOrderRef + vpReceiptRef + vpLineOrderNo + vpDateCreated + vpTimeCreated
  // Idx 1: vpOrderRef + vpTransRef + vpLineOrderNo + vpDateCreated + vpTimeCreated
  TOrderPaymentsVATTrackIndex = (vpIdxReceiptRef=0, vpIdxTransRef=1);

  //------------------------------

  // Type of row in the VAT Payment Details table
  enumOrderPaymentsVATPayDetailsType = (
                                         vptSORPayment = 0,         // Payment against an SOR
                                         vptSDNPayment = 1,         // Payment against an SDN
                                         vptSINPayment = 2,         // Payment against an SIN
                                         vptSORValueRefund = 3,     // Refund against an SOR
                                         vptSINValueRefund = 4,     // Value Refund against an SIN - generates -SRC
                                         vptSINStockRefund = 5,     // Stock Refund against an SIN - SRF generated instead of -SRC
                                         vptMatching = 6            // Invoice to Payment Matching
                                       );

Const
  vpOrderRefLen = 10;
  vpReceiptRefLen = 10;
  vpTransRefLen = 10;

  VATPayDetailsTypePaymentSet = [vptSORPayment, vptSDNPayment, vptSINPayment];
  VATPayDetailsTypeRefundSet = [vptSORValueRefund, vptSINValueRefund, vptSINStockRefund];

  //------------------------------

Type
  // Record Structure for Btrieve File
  OrderPaymentsVATPayDetailsRecType = Record
    vpOrderRef      : String[vpOrderRefLen];    // SOR OurRef - originating order that all Order Payment transactions originate from
    vpReceiptRef    : String[vpReceiptRefLen];  // Payment OurRef (SRC) for payment taken against SOR/SDN/SIN
    vpTransRef      : String[vpTransRefLen];    // OurRef of related transaction, e.g. SDN or SIN a payment was made against
    vpLineOrderNo   : LongInt;         // Line sequence within OPVATPAY
    vpSORABSLineNo  : LongInt;         // Absolute Line Number from SOR, maps onto SOPLineNo on SDN/SIN

    vpType          : enumOrderPaymentsVATPayDetailsType;  // Operation type / purpose

    vpCurrency      : Byte;            // SOR Currency and therefore SDN/SIN/SRC currency
    vpDescription   : String[60];      // Text description of SOR line for printing VAT Receipts
    vpVATCode       : Char;            // SOR Line VAT Code
    vpGoodsValue    : Double;          // Goods Value paid/refunded
    vpVATValue      : Double;          // VAT Value paid/refunded

    vpUserName      : String[10];      // Exchequer User at point row inserted
    vpDateCreated   : String[8];       // Date row inserted in YYYYMMDD format
    vpTimeCreated   : String[6];       // Time row inserted in HHMMSS format

    ExclamationChar : Char;            // '!' - PERVASIVE ONLY - exists purely to solve Btrieve/code issues around indexes ending with an Integer segment
    Spare           : Array [1..255] of Byte;  // For future use - 404 bytes total rec size
  End; // OrderPaymentsVATPayDetailsRecType

  //------------------------------

  // Btrieve File Definition
  OrderPaymentsVATPayDetailsBtrieveFileDefinitionType = Record
    RecLen    :  SmallInt;
    PageSize  :  SmallInt;
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  Array [1..4] Of Char;
    KeyBuff   :  Array [1..10] Of KeySpec;
    AltColt   :  AltColtSeq;
  End; // OrderPaymentsVATPayDetailsBtrieveFileDefinitionType

  //------------------------------

  // Class for accessng the Pervasive.SQL Cust\AccountContact.Dat data file
  TOrderPaymentsVATPayDetailsBtrieveFile = Class(TBaseBtrieveFile)
  Private
    // Internal typed data buffer for btrieve access
    FOrderPaymentsVATPayDetailsRec : OrderPaymentsVATPayDetailsRecType;
    // Interface file structure definition
    FOrderPaymentsVATPayDetailsFileDef : OrderPaymentsVATPayDetailsBtrieveFileDefinitionType;

    // Defines the Btrieve File Structure for the Cust\ContactRole.Dat table
    Procedure DefineOrderPaymentsVATPayDetailsFileStructure;
  Protected
    Function GetRecordPointer : Pointer;
    Function GetIndex : TOrderPaymentsVATTrackIndex;
    Procedure SetIndex(Value : TOrderPaymentsVATTrackIndex);
  Public
    Property Index : TOrderPaymentsVATTrackIndex Read GetIndex Write SetIndex;
    Property RecordPointer : Pointer Read GetRecordPointer;
    Property VATPayDetails : OrderPaymentsVATPayDetailsRecType Read FOrderPaymentsVATPayDetailsRec Write FOrderPaymentsVATPayDetailsRec;

    Constructor Create;
    Constructor CreateWithClientId (Const ReplacementClientId : ClientIdType);

    // Returns a padded Order/Receipt Reference key for vpIdxReceiptRef
    Function BuildReceiptRefKey (Const OrderRef : String;
                                 Const ReceiptRef : String = '';
                                 Const LineNo : LongInt = 0) : String;
    // Returns a padded Order/Trans Reference key for vpIdxTransRef
    Function BuildTransRefKey (Const OrderRef : String;
                               Const TransRef : String = '';
                               Const LineNo : LongInt = 0) : String;
    Procedure InitialiseRecord;
    procedure Unlock;
  End; // TOrderPaymentsVATPayDetailsBtrieveFile

  // Builds a padded OrderRef key suitable for populating the vpOrderRef field or for a DB lookup
  Function PadOrderRefKey (Const OrderRef : String) : String;
  // Builds a padded ReceiptRef key suitable for populating the vpReceiptRef field or for a DB lookup
  Function PadReceiptRefKey (Const ReceiptRef : String) : String;
  // Builds a padded TransRef key suitable for populating the vpTransRef field or for a DB lookup
  Function PadTransRefKey (Const TransRef : String) : String;

  // Correctly initialises a blank OrderPaymentsVATPayDetailsRecType record
  Procedure InitialiseVATPayRec (Var VATPayRec : OrderPaymentsVATPayDetailsRecType);

Implementation

Uses Dialogs, SysUtils, ETStrU;

//=========================================================================

// Builds a padded OrderRef key suitable for populating the vpOrderRef field or for a DB lookup
Function PadOrderRefKey (Const OrderRef : String) : String;
Begin // PadOrderRefKey
  Result := LJVar(OrderRef, vpOrderRefLen);
End; // PadOrderRefKey

// Builds a padded ReceiptRef key suitable for populating the vpReceiptRef field or for a DB lookup
Function PadReceiptRefKey (Const ReceiptRef : String) : String;
Begin // PadReceiptRefKey
  Result := LJVar(ReceiptRef, vpReceiptRefLen)
End; // PadReceiptRefKey

// Builds a padded TransRef key suitable for populating the vpTransRef field or for a DB lookup
Function PadTransRefKey (Const TransRef : String) : String;
Begin // PadTransRefKey
  Result := LJVar(TransRef, vpTransRefLen)
End; // PadTransRefKey

//-------------------------------------------------------------------------

// Correctly initialises a blank TOrderPaymentsVATPayDetailsBtrieveFile record
Procedure InitialiseVATPayRec (Var VATPayRec : OrderPaymentsVATPayDetailsRecType);
Begin // InitialiseVATPayRec
  FillChar(VATPayRec, SizeOf(VATPayRec), #0);

  // Date row inserted in YYYYMMDD format
  VATPayRec.vpDateCreated := FormatDateTime ('yyyymmdd', Now);
  // Time row inserted in HHMMSS format
  VATPayRec.vpTimeCreated := FormatDateTime ('hhnnss', Now);
  // Flag char required for Pervasive indexes ending in Integers
  VATPayRec.ExclamationChar := '!';
End; // InitialiseVATPayRec

//=========================================================================

Constructor TOrderPaymentsVATPayDetailsBtrieveFile.Create;
Begin // Create
  Inherited Create;

  // Link in data record
  FDataRecLen := SizeOf(FOrderPaymentsVATPayDetailsRec);
  FDataRec := @FOrderPaymentsVATPayDetailsRec;

  // link in File Definition
  FDataFileLen := SizeOf(FOrderPaymentsVATPayDetailsFileDef);
  FDataFile := @FOrderPaymentsVATPayDetailsFileDef;
  DefineOrderPaymentsVATPayDetailsFileStructure;

  //We're sharing a Client ID with the other Order Payment data access objects, so we can't call
  //OpenCompany as that would close all open files for the Client ID
  FBypassOpenCompany := True;
End; // Create

//------------------------------

Constructor TOrderPaymentsVATPayDetailsBtrieveFile.CreateWithClientId (Const ReplacementClientId : ClientIdType);
Var
  ObjClientId : ^ClientIdType;
Begin // CreateWithClientId
  // Call the standard constructor above
  Create;

  // Replace the clientId with that passed in
  ObjClientId := ClientId;
  ObjClientId^ := ReplacementClientId;
End; // CreateWithClientId

//-------------------------------------------------------------------------

// Defines the Btrieve File Structure for the Trans\OPVATPay.Dat table
Procedure TOrderPaymentsVATPayDetailsBtrieveFile.DefineOrderPaymentsVATPayDetailsFileStructure;
Begin // DefineOrderPaymentsVATPayDetailsFileStructure
  // Define the Btrieve file structure
  FillChar(FOrderPaymentsVATPayDetailsFileDef, SizeOf(FOrderPaymentsVATPayDetailsFileDef), #0);
  With FOrderPaymentsVATPayDetailsFileDef Do
  Begin
    // Set the size of the Btrieve Record
    RecLen := FDataRecLen;

    // Define the basic Btrieve File properties
    PageSize := DefPageSize;
    Variable := B_Variable + B_Compress + B_BTrunc; // Used for max compression

    // Define the indexes
    NumIndex := 2;

    // Idx 0: vpOrderRef + vpReceiptRef + vpLineOrderNo + vpDateCreated + vpTimeCreated  (vpIdxReceiptRef)
    With KeyBuff[1] Do
    Begin
      // Position of indexed field in bytes offset from start of record
      KeyPos   := BtKeyPos(@FOrderPaymentsVATPayDetailsRec.vpOrderRef[1], @FOrderPaymentsVATPayDetailsRec);
      // length of segment in bytes
      KeyLen   := SizeOf(FOrderPaymentsVATPayDetailsRec.vpOrderRef) - 1;
      // Flags for index
      KeyFlags := DupModSeg + AltColSeq;
    End; // With KeyBuff[1]
    With KeyBuff[2] Do
    Begin
      // Position of indexed field in bytes offset from start of record
      KeyPos   := BtKeyPos(@FOrderPaymentsVATPayDetailsRec.vpReceiptRef[1], @FOrderPaymentsVATPayDetailsRec);
      // length of segment in bytes
      KeyLen   := SizeOf(FOrderPaymentsVATPayDetailsRec.vpReceiptRef) - 1;
      // Flags for index
      KeyFlags := DupModSeg + AltColSeq;
    End; // With KeyBuff[2]
    With KeyBuff[3] Do
    Begin
      // Position of indexed field in bytes offset from start of record
      KeyPos   := BtKeyPos(@FOrderPaymentsVATPayDetailsRec.vpLineOrderNo, @FOrderPaymentsVATPayDetailsRec);
      // length of segment in bytes
      KeyLen   := SizeOf(FOrderPaymentsVATPayDetailsRec.vpLineOrderNo);
      // Flags for index
      KeyFlags := DupModSeg;
      // Sort as Integer
      ExtTypeVal := BInteger;
    End; // With KeyBuff[3]
    With KeyBuff[4] Do
    Begin
      // Position of indexed field in bytes offset from start of record
      KeyPos   := BtKeyPos(@FOrderPaymentsVATPayDetailsRec.vpDateCreated[1], @FOrderPaymentsVATPayDetailsRec);
      // length of segment in bytes
      KeyLen   := SizeOf(FOrderPaymentsVATPayDetailsRec.vpDateCreated) - 1;
      // Flags for index
      KeyFlags := DupModSeg;
    End; // With KeyBuff[4]
    With KeyBuff[5] Do
    Begin
      // Position of indexed field in bytes offset from start of record
      KeyPos   := BtKeyPos(@FOrderPaymentsVATPayDetailsRec.vpTimeCreated[1], @FOrderPaymentsVATPayDetailsRec);
      // length of segment in bytes
      KeyLen   := SizeOf(FOrderPaymentsVATPayDetailsRec.vpTimeCreated) - 1;
      // Flags for index
      KeyFlags := DupMod;
    End; // With KeyBuff[4]

    // Idx 1: vpOrderRef + vpTransRef + vpLineOrderNo + vpDateCreated + vpTimeCreated  (vpIdxReceiptRef)
    KeyBuff[6] := KeyBuff[1];
    With KeyBuff[7] Do
    Begin
      // Position of indexed field in bytes offset from start of record
      KeyPos   := BtKeyPos(@FOrderPaymentsVATPayDetailsRec.vpTransRef[1], @FOrderPaymentsVATPayDetailsRec);
      // length of segment in bytes
      KeyLen   := SizeOf(FOrderPaymentsVATPayDetailsRec.vpTransRef) - 1;
      // Flags for index
      KeyFlags := DupModSeg + AltColSeq;
    End; // With KeyBuff[7]
    KeyBuff[8] := KeyBuff[3];
    KeyBuff[9] := KeyBuff[4];
    KeyBuff[10] := KeyBuff[5];

    // Definition for AutoConversion to UpperCase
    AltColt:=UpperALT;
  End; // With FOrderPaymentsVATPayDetailsFileDef
End; // DefineOrderPaymentsVATPayDetailsFileStructure

//-------------------------------------------------------------------------

Function TOrderPaymentsVATPayDetailsBtrieveFile.GetRecordPointer : Pointer;
Begin // GetRecordPointer
  Result := FDataRec;
End; // GetRecordPointer

//------------------------------

Function TOrderPaymentsVATPayDetailsBtrieveFile.GetIndex : TOrderPaymentsVATTrackIndex;
Begin // GetIndex
  Result := TOrderPaymentsVATTrackIndex(FIndex);
End; // GetIndex
Procedure TOrderPaymentsVATPayDetailsBtrieveFile.SetIndex(Value : TOrderPaymentsVATTrackIndex);
Begin // SetIndex
  FIndex := Ord(Value);
End; // SetIndex

//-------------------------------------------------------------------------

Procedure TOrderPaymentsVATPayDetailsBtrieveFile.InitialiseRecord;
Begin // InitialiseRecord
  InitialiseVATPayRec (FOrderPaymentsVATPayDetailsRec);
End; // InitialiseRecord

//-------------------------------------------------------------------------

procedure TOrderPaymentsVATPayDetailsBtrieveFile.Unlock;
begin
  Cancel;
end;

//-------------------------------------------------------------------------

// Returns a padded Order/Receipt Reference key for vpIdxReceiptRef
Function TOrderPaymentsVATPayDetailsBtrieveFile.BuildReceiptRefKey (Const OrderRef : String;
                                                                    Const ReceiptRef : String = '';
                                                                    Const LineNo : LongInt = 0) : String;
Begin // BuildReceiptRefKey
  Result := LJVar(OrderRef, SizeOf(FOrderPaymentsVATPayDetailsRec.vpOrderRef) - 1);   // Pad to full field length

  // If the Receipt OurRef is supplied then build the full key, otherwise leave it as the part key
  If (ReceiptRef <> '') Then
    Result := Result + LJVar(ReceiptRef, SizeOf(FOrderPaymentsVATPayDetailsRec.vpReceiptRef) - 1) +   // Pad to full field length
              FullNomKey(LineNo);
End; // BuildReceiptRefKey

//------------------------------

// Returns a padded Order/Trans Reference key for vpIdxTransRef
Function TOrderPaymentsVATPayDetailsBtrieveFile.BuildTransRefKey (Const OrderRef : String;
                                                                  Const TransRef : String = '';
                                                                  Const LineNo : LongInt = 0) : String;
Begin // BuildTransRefKey
  Result := LJVar(OrderRef, SizeOf(FOrderPaymentsVATPayDetailsRec.vpOrderRef) - 1);   // Pad to full field length

  // If the Trans OurRef is supplied then build the full key, otherwise leave it as the part key
  If (TransRef <> '') Then
    Result := Result + LJVar(TransRef, SizeOf(FOrderPaymentsVATPayDetailsRec.vpTransRef) - 1) +   // Pad to full field length
              FullNomKey(LineNo);
End; // BuildTransRefKey

//=========================================================================

Initialization
  // Check for record structure size
  If (SizeOf(OrderPaymentsVATPayDetailsRecType) <> 404) Then
    ShowMessage('OrderPaymentsVATPayDetailsRecType - Expected Size=404, Actual Size= ' + IntToStr(SizeOf(OrderPaymentsVATPayDetailsRecType)));
End.