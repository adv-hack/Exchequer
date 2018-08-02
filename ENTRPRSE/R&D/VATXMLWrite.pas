unit VATXMLWrite;

// ABSEXCH-13793.  Include VAT 100 XML output.

// The TXMLVATReturn class is derived from the TCISXMLBase class because it
//  provides a lot of the functionality of creating an XML file suitable for
//  online submission to HMRC.
// Some of the attributes of TCISXMLBase have been made protected so that they
//  become accessible by the derived class.
// Some of the methods of TCISXMLBase have been made virtual so that they may 
//  be overridden by the derived class.

interface

uses
  Contnrs, GMXML, BTSupU3, CISWrite,
  idhash,
  IdHashMessageDigest, // For encrypting the VAT100 Password for the XML file
  GlobVar;

type
  // Creates an XML Version of the VAT Return
  TXMLVATReturn = class(TCISXMLBase)
  public
    VATReportParams : VATRepPtr;
  
    constructor Create(aXMLVat100Data : array of double);

    function BuildVATXMLFilename(theDate : LongDate) : string;
    procedure WriteXMLToFile(const FileName: string); override;
  protected
    // Overrides
    procedure WriteMessageDetails; override;
    procedure WriteSenderDetails;  override;
    procedure WriteGovTalkDetails; override;
    procedure WriteKeys; override;
    procedure WriteBody; override;
    procedure WriteIRHeader; override;
    procedure CreateIRMark; override;

    // new methods
    procedure WriteVATKeys;
    procedure WriteVATReturn;
  private
    vatRegNumber : string;
    Vat100Data : array of double;
  end;

// helper functions
procedure MD5Bytes(const aPlainText : string; var byteArr : array of byte);
function  EncodeBase64(inStr : string) : string; overload;
function  EncodeBase64(inBytes : array of byte) : string; overload;
  
implementation

uses
  Classes,
  SysUtils, CISXCnst, VATXMLConst, InternetFiling_TLB, ActiveX, VarConst,
  EncryptionUtils,     // For decrypting the VAT100 Sender ID and Password
  IDCoderMIME;

//==============================================================================
// XML VAT Return class constructor
constructor TXMLVATReturn.Create(aXMLVat100Data : array of double);
var
  index : integer;
begin
  // Call the base class constructor
  inherited Create;

  // Our Vendor ID is different for VAT
  VendorID := VAT_VENDOR_ID;

  SetLength(Vat100Data, Length(aXMLVat100Data));
  for index := 0 to Length(aXMLVat100Data)-1 do
  begin
    Vat100Data[index] := aXMLVat100Data[index];
  end;
  
//  FDocument.AutoIndent := false;
end;


//------------------------------------------------------------------------------
procedure TXMLVATReturn.WriteMessageDetails;
begin
  // <MessageDetails> block
  FDocument.Nodes.AddOpenTag(MESSAGE_DETAILS);
    FDocument.Nodes.AddLeaf(MESSAGE_CLASS).AsString := MESSAGE_CLASS_VAT_RETURN;
    FDocument.Nodes.AddLeaf(MESSAGE_QUALIFIER).AsString := 'request';
    FDocument.Nodes.AddLeaf(MESSAGE_FUNCTION).AsString := 'submit';
    FDocument.Nodes.AddLeaf(MESSAGE_CORRELATION_ID); // Must be a null tag
    FDocument.Nodes.AddLeaf(MESSAGE_TRANSFORMATION).AsString := 'XML';
  FDocument.Nodes.AddCloseTag;
end;

//------------------------------------------------------------------------------
procedure TXMLVATReturn.WriteSenderDetails;
var
  SenderIDEnc       : string;
  SenderID          : string;
  SenderAuthEnc     : string; // The encrypted password
  SenderAuth        : string; // The unencrypted password
  SenderAuthLC      : string; // lower case version of the password
  SenderAuthBase64  : string; // Base64 encoded version of the MD5 hash
  SenderAuthMD5Bytes : array [0..15] of byte;
begin
  FDocument.Nodes.AddOpenTag(SENDER_DETAILS);                      // <SenderDetails>
    FDocument.Nodes.AddOpenTag(SENDER_ID_AUTHENTICATION_HEAD);     // <IDAuthentication>
    
      SenderIDEnc := SyssVat.VATRates.VAT100UserID;
      // Decrypt the SenderID
      SenderID := DecryptVAT100UserId(SenderIDEnc);
      FDocument.Nodes.AddLeaf(SENDER_ID).AsString := SenderID;     // <SenderID>
      
      FDocument.Nodes.AddOpenTag(SENDER_ID_AUTHENTICATION);        // <Authentication>
      
      SenderAuthEnc := SyssVat.VATRates.VAT100Password;
      SenderAuth := DecryptVAT100Password(SenderAuthEnc);
        
      // According to the document
      // http://www.hmrc.gov.uk/schemas/GatewayDocumentSubmissionProtocol_V3.1.pdf
      // the password value must be:
      // - Converted to lowercase
      // - MD5 Hashed
      // - BASE64 encoded.
      // NOTE: the MD5 hash must be an array of bytes - not a string of hex codes.
      
      // Set the password to lower case.
      SenderAuthLC := Lowercase(SenderAuth);

        // This may be "clear" or "MD5"
        FDocument.Nodes.AddLeaf(SENDER_ID_METHOD).AsString := 'MD5';
        
        // - MD5 hashed
        MD5Bytes(SenderAuthLC, SenderAuthMD5Bytes);
        
        // - Base64 encoded.
        SenderAuthBase64 := EncodeBase64(SenderAuthMD5Bytes);

        FDocument.Nodes.AddLeaf(SENDER_ID_VALUE).AsString := SenderAuthBase64;

        SenderAuth     := ''; // Clear the unencrypted versions of the password.
        SenderAuthLC   := '';
        
      FDocument.Nodes.AddCloseTag; //  </Authentication>
      
    FDocument.Nodes.AddCloseTag; // </Authentication>
  FDocument.Nodes.AddCloseTag; // </SenderDetails>
end;


//------------------------------------------------------------------------------
procedure MD5Bytes(const aPlainText : string; var byteArr : array of byte);
type
  THashRec = packed record
    case integer of
      0:
        (md5lwArr : T4x4LongWordRecord);
      1:
        (md5byteArr : array [0..15] of byte);
  end;
var
  idMD5 : TIdHashMessageDigest5;
  md5Hash : THashRec;
  index : integer;
begin
  idMD5 := TIdHashMessageDigest5.Create;
  
  try
    md5Hash.md5lwArr := idMD5.HashValue(aPlainText);
    for index := 0 to 15 do
    begin
      byteArr[index] := md5Hash.md5byteArr[index];
    end;
  finally
    idMD5.Free;
  end;
end;

//------------------------------------------------------------------------------
// Called by the other version of EncodeBase64
function EncodeBase64(inStr : string) : string;
var
  MIMEEncoder : TIdEncoderMIME;
begin
  MIMEEncoder := TIdEncoderMIME.Create;

  result := MIMEEncoder.Encode(inStr);
end;

//------------------------------------------------------------------------------
function  EncodeBase64(inBytes : array of byte) : string;
var
  inStr : string;
  index : integer;
begin
  inStr := '';
  for index := 0 to Length(inBytes)-1 do
  begin
    inStr := inStr + chr(inBytes[index]);
  end;

  result := EncodeBase64(inStr);
end;


//------------------------------------------------------------------------------
procedure TXMLVATReturn.WriteGovTalkDetails;
begin
  FDocument.Nodes.AddOpenTag(GOV_TALK_DETAILS);

    WriteKeys;
  
    //Channel
    FDocument.Nodes.AddOpenTag(GOV_TALK_CHANNEL_ROUTING);
      FDocument.Nodes.AddOpenTag(GOV_TALK_CHANNEL);
        FDocument.Nodes.AddLeaf(GOV_TALK_CHANNEL_URI).AsString := FDataRec.cisVendorID;
        
        // Name of application used to submit the report.  We're not actually 
        //  submitting it, so should we put Exchequer in here?
        FDocument.Nodes.AddLeaf(GOV_TALK_CHANNEL_PRODUCT).AsString := FDataRec.cisProductName;
        // Software version number
        FDocument.Nodes.AddLeaf(GOV_TALK_CHANNEL_VERSION).AsString := FDataRec.cisProductVersion;
      FDocument.Nodes.AddCloseTag; //Channel
    FDocument.Nodes.AddCloseTag; //Channel Routing
  FDocument.Nodes.AddCloseTag; //GovTalk Details
end;

//------------------------------------------------------------------------------
procedure TXMLVATReturn.WriteKeys;
var
  workStr      : string;
  numbers      : string;
  index        : integer;
  thisChar     : string;
begin
  // VAT Reg number is 9-digit numeric but might be stored in Exchequer with a 
  // GB prefix and spaces. Eg. GB 123 4567 89
  // We're not validating the VAT number, but we do need to apply some intelligence
  //  over which characters to use, and strip the prefix and spaces.
  
  numbers := '0123456789';
  vatRegNumber := '';
  workStr := Syss.UserVATReg;
  // Strip any spaces
  workStr := StringReplace(workStr, ' ', '', [rfReplaceAll]);
  // Strip any alphabetic characters
  for index := 1 to length(workStr) do
  begin
    thisChar := Copy(workStr, index, 1);
    if Pos(thisChar, numbers) > 0 then
      vatRegNumber := vatRegNumber + thisChar;
  end;

  FDocument.Nodes.AddOpenTag(GOV_TALK_KEYS);

    with FDocument.Nodes.AddLeaf(GOV_TALK_KEY) do
    begin
      Attributes.AddAttribute(GOV_TALK_TYPE, VAT_REG_NUMBER);
      AsString := vATRegNumber;
    end;

  FDocument.Nodes.AddCloseTag; //Keys
end;

//------------------------------------------------------------------------------
procedure TXMLVATReturn.WriteVATKeys;
begin
  FDocument.Nodes.AddOpenTag(VAT_KEYS);

    with FDocument.Nodes.AddLeaf(VAT_KEY) do
    begin
      Attributes.AddAttribute(GOV_TALK_TYPE, VAT_REG_NUMBER);
      AsString := vatRegNumber;
    end;

  FDocument.Nodes.AddCloseTag; //Keys
end;

//------------------------------------------------------------------------------
procedure TXMLVATReturn.WriteBody;
begin
  FDocument.Nodes.AddOpenTag(IR_BODY);
    with FDocument.Nodes.AddOpenTag(VAT_IR_ENVELOPE) do
      Attributes.AddAttribute(VAT_XMLNS, VAT_IR_URL);

      WriteIRHeader;
      WriteVATReturn;

    FDocument.Nodes.AddCloseTag; // vat:IRenvelope
  FDocument.Nodes.AddCloseTag; //Body
end;

//------------------------------------------------------------------------------
procedure TXMLVATReturn.WriteIRHeader;
var
  period : string;
begin
  FDocument.Nodes.AddOpenTag(VAT_IR_HEADER);
    WriteVATKeys;

    period := Copy(VatReportParams.VATEndD, 1, 4) + '-' + Copy(VatReportParams.VATEndD, 5, 2);
    FDocument.Nodes.AddLeaf(VAT_PERIOD_ID).AsString := period;

    //--------------------------------------------------------------------------
    // NOTE: Do not add an empty IRMark tag at this point, as it appears to generate
    //   an incorrect IRMark if you do.
    // The FBI functions add the IRMark in slightly the wrong format, but we
    // post-process it to correct it in the WriteXMLToFile procedure.
    //--------------------------------------------------------------------------

    FDocument.Nodes.AddLeaf(VAT_SENDER).AsString := Trim(SyssVat.VATRAtes.VAT100SenderType);

  FDocument.Nodes.AddCloseTag; // vat:IRHeader
end;


//------------------------------------------------------------------------------
procedure TXMLVATReturn.WriteVATReturn;
var
  multiplier : double;
begin
  // PKR. 11/06/2013.  Modified to use the values calculated by Report8U instead of
  //  recalculating them all over again.

  // PKR. 11/09/2015.  ABSEXCH-16833. Some of the values in the calculated report have different signs
  // to those that are required on the VAT 100 report, so we need to do a bit of pre-processing on them.

  // PKR. 11/09/2015.  Box 7 should be the value calculated in the report x -1
  Vat100Data[6] := Vat100Data[6] * -1.0;
  // Work out what sign it now has so we can apply it to Box 4
  multiplier := 1.0;
  if (Vat100Data[6] < 0.0) then
  begin
    multiplier := -1.0;
  end;

  // PKR. 11/09/2015. The value in Box 4 should have the same sign as that in box 7, because its
  // value is derived from that in Box 7.
  // Get the absolute value and then apply the sign multiplier.
  Vat100Data[3] := abs(Vat100Data[3]) * multiplier;

  // PKR. 11/09/2015. The value in this box should be the absolute value of the difference
  // between the absolute values of boxes 3 and 4.  Exchequer calculates the difference, so
  // we only have to take the absolute value.
  // PKR. 28/09/2015. Updated calculation to take the absolute value of the amount calculated by Exchequer.
  Vat100Data[4] := abs(Vat100Data[4]);

  // PKR. 11/09/2015. The value in Box 9 should be the value calculated in the report x -1
  Vat100Data[8] := Vat100Data[8] * -1.0;

  //----------------------------------------------------------------------------
  // Write to the XML file.
  FDocument.Nodes.AddOpenTag(VAT_DECLARATION_REQUEST);
    FDocument.Nodes.AddLeaf(VAT_VAT_DUE_ON_OUTPUTS).AsString         := Format('%f', [Vat100Data[0]]);  // Box 1
    FDocument.Nodes.AddLeaf(VAT_VAT_DUE_ON_EC_ACQUISITIONS).AsString := Format('%f', [Vat100Data[1]]);  // Box 2
    FDocument.Nodes.AddLeaf(VAT_TOTALVAT).AsString                   := Format('%f', [Vat100Data[2]]);  // Box 3
    FDocument.Nodes.AddLeaf(VAT_VAT_RECLAIMED_ON_INPUTS).AsString    := Format('%f', [Vat100Data[3]]);  // Box 4
    FDocument.Nodes.AddLeaf(VAT_NET_VAT).AsString                    := Format('%f', [Vat100Data[4]]);  // Box 5

    // In Boxes 6..9, the HMRC expects integer pounds (no pence), hence the use of Trunc().
    FDocument.Nodes.AddLeaf(VAT_NET_SALES_AND_OUTPUTS).AsString      := Format('%d', [Trunc(Vat100Data[5])]);  // Box 6
    FDocument.Nodes.AddLeaf(VAT_NET_PURCHASES_AND_INPUTS).AsString   := Format('%d', [Trunc(Vat100Data[6])]);  // Box 7
    FDocument.Nodes.AddLeaf(VAT_NET_EC_SUPPLIES).AsString            := Format('%d', [Trunc(Vat100Data[7])]);  // Box 8
    FDocument.Nodes.AddLeaf(VAT_NET_EC_ACQUISITIONS).AsString        := Format('%d', [Trunc(Vat100Data[8])]);  // Box 9
  FDocument.Nodes.AddCloseTag; // vat:VATDeclarationRequest
end;


//------------------------------------------------------------------------------
// Creates a filename of the format VATyymm.xml
function TXMLVATReturn.BuildVATXMLFilename(theDate : LongDate) : string;
begin
  // Characters 3..6 are the last 2 digits of the year, followed by the month.
  result := 'VAT' + Copy(theDate, 3, 4) + '.xml';
end;


//------------------------------------------------------------------------------
procedure TXMLVATReturn.CreateIRMark;
//Uses Mark Green's FBI Components to calculate the IR Mark and add it into the xml

  {retrieve necessary name space to be able to create the irmark}
  function GetNameSpace(pXML: WideString): String;
  var
    lXml : TGmXML;
  begin
    lXml := TGmXML.Create(nil);
    lXml.Text := pXML;

    with lXml.Nodes do
    try
      // Differs from ancestor class method by the Node Name and xmlns attibute
      Result := NodeByName[VAT_IR_ENVELOPE].Attributes.ElementByName[VAT_XMLNS].Value;
    finally
      lXMl.Free;
    end; {with lXml.Nodes do}
  end; {function GetNameSpace(pXML: WideString): String;}


var
  FPosting: _Posting;
  wsXML : WideString;
  lNameSpace: WideString;
begin
  CoInitialize(nil);
  FPosting := CoPosting.Create;
  Try
    // Copy the existing XML to a widestring for use by the FBI component that
    //  creates the IRMark.
    wsXML := FDocument.Text;
    
    //Remove any tabs
    wsXML := StringReplace(wsXML, Chr(9), '', [rfReplaceAll]);
    // Remove CR
    wsXML := StringReplace(wsXML, #13, '', [rfReplaceAll]);
    // Remove LF
    wsXML := StringReplace(wsXML, #10, '', [rfReplaceAll]);

    // Remove spaces between tags
    while Pos(' <', wsXML) > 0 do
      wsXML := StringReplace(wsXML, ' <', '<', [rfReplaceAll]);
    
    // Get the namespace from the IRenvelope tag
    lNameSpace := GetNameSpace(wsXML);
    
    // Create and insert the IRMark.  This ends up in slightly the wrong format,
    //  so we need to modify it afterwards.
//    FDataRec.cisIRMark := FPosting.AddIRMark_2(wsXML, lNameSpace);

    // Remove CR and LF
    wsXML := StringReplace(wsXML, #13, '', [rfReplaceAll]);
    wsXML := StringReplace(wsXML, #10, '', [rfReplaceAll]);
    // Remove spaces between tags
    while Pos(' <', wsXML) > 0 do
      wsXML := StringReplace(wsXML, ' <', '<', [rfReplaceAll]);
    
    FDocument.Nodes.Clear;

    FDocument.Text := wsXML;
  Finally
    FPosting := nil;
  End;

  CoUninitialize;
end;


//------------------------------------------------------------------------------
procedure TXMLVATReturn.WriteXMLToFile(const FileName: string);
var
  theXML : string;
  slXML : TStringList;
begin
  WriteMessage;

  theXML := FDocument.Text;
  // Remove CR and LF
  theXML := StringReplace(theXML, #13, '', [rfReplaceAll]);
  theXML := StringReplace(theXML, #10, '', [rfReplaceAll]);

  // Remove spaces between tags
  while Pos(' <', theXML) > 0 do
    theXML := StringReplace(theXML, ' <', '<', [rfReplaceAll]);
  
  // Modify the resulting IRmark so that it will validate.
  // We need to
  //  1) add the 'vat:' namespace to the tag
  //  2) Remove the 'xmlns = ""' attribute
  theXML := StringReplace(theXML, '<IRmark', 
                                  '<vat:IRmark', [rfReplaceAll]);
  theXML := StringReplace(theXML, 'xmlns=""', '', [rfReplaceAll]);
  theXML := StringReplace(theXML, '</IRmark>', '</vat:IRmark>', [rfReplaceAll]);
    
  slXML := TStringList.Create;
  slXML.Text := theXML;
  slXML.SaveToFile(filename);
end;


end.
