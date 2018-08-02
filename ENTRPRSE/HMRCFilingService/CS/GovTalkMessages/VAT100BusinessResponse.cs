using System;
using System.Web;
using System.Xml;
using System.Xml.Serialization;
using System.Collections.Generic;

namespace HMRCFilingService.GovTalkMessages
  {
  [Serializable, XmlRoot(ElementName = "GovTalkMessage", Namespace = "http://www.govtalk.gov.uk/CM/envelope")]
  public class VAT100_BusinessResponseMessage
    {
    [XmlElement(ElementName = "EnvelopeVersion")]
    public string EnvelopeVersion { get; set; }

    [XmlElement(ElementName = "Header")]
    public GovTalkMessage_Header Header { get; set; }

    [XmlElement(ElementName = "GovTalkDetails")]
    public VAT100BusinessResponseDetails GovTalkDetails { get; set; }

    [XmlElement(ElementName = "Body")]
    public VAT100BusinessResponseBody Body { get; set; }

    public VAT100_BusinessResponseMessage()
      {
      EnvelopeVersion = "2.0";
      }
    } // VAT100ResponseMessage

  //-----------------------------------------------------------------------------------------------
  [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.govtalk.gov.uk/CM/envelope")]
  public class VAT100BusinessResponseDetails
    {
    [XmlElement(ElementName = "Keys")]
    public GovTalkMessage_GovTalkDetails_Keys Keys { get; set; }

    [XmlElement(ElementName = "GovTalkErrors")]
    public List<GovTalkError> GovTalkErrors { get; set; }
    }


  //-----------------------------------------------------------------------------------------------
  [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.govtalk.gov.uk/CM/envelope")]
  public class GovTalkError
    {
    [XmlElement(ElementName = "Error")]
    public GovTalkErrorsError Error { get; set; }
    }

  //-----------------------------------------------------------------------------------------------
  [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.govtalk.gov.uk/CM/envelope")]
  public class GovTalkErrorsError
    {
    [XmlElement(ElementName = "RaisedBy")]
    public string RaisedBy { get; set; }

    [XmlElement(ElementName = "Number")]
    public int Number { get; set; }

    [XmlElement(ElementName = "Type")]
    public string Type { get; set; }

    [XmlElement(ElementName = "Text")]
    public string Text { get; set; }

    [XmlElement(ElementName = "Location")]
    public string Location { get; set; }
    }

  //-----------------------------------------------------------------------------------------------
  [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.govtalk.gov.uk/CM/envelope")]
  public class VAT100BusinessResponseBody
    {
    [XmlElement(ElementName = "SuccessResponse", Namespace = "http://www.inlandrevenue.gov.uk/SuccessResponse")]
    public BodySuccessResponse SuccessResponse { get; set; }
    }

  //-----------------------------------------------------------------------------------------------
  [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.inlandrevenue.gov.uk/SuccessResponse")]
  public class BodySuccessResponse
    {
    [XmlElement(ElementName = "IRmarkReceipt")]
    public IRmarkReceipt IRmarkReceipt { get; set; }

    [XmlElement(ElementName = "Message")]
    public string Message { get; set; }

    [XmlElement(ElementName = "AcceptedTime")]
    public string AcceptedTime { get; set; }

    [XmlElement(ElementName = "ResponseData")]
    public BodySuccessResponseResponseData ResponseData { get; set; }
    }

  //-----------------------------------------------------------------------------------------------
  [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.inlandrevenue.gov.uk/SuccessResponse")]
  public class IRmarkReceipt
    {
    [XmlElement(ElementName = "Signature")]
    public IRmarkReceiptSignature Signature { get; set; }

    [XmlElement(ElementName = "Message", Namespace = "http://www.inlandrevenue.gov.uk/SuccessResponse")]
    public string IRmarkReceiptMessage { get; set; }
    }

  //-----------------------------------------------------------------------------------------------
  [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.w3.org/2000/09/xmldsig#")]
  public class IRmarkReceiptSignature
    {
    [XmlElement(ElementName = "SignedInfo", Namespace = "http://www.w3.org/2000/09/xmldsig#")]
    public IRmarkReceiptSignatureSignedInfo SignedInfo { get; set; }

    [XmlElement(ElementName = "SignatureValue", Namespace = "http://www.w3.org/2000/09/xmldsig#")]
    public string SignatureValue { get; set; }

    [XmlElement(ElementName = "KeyInfo", Namespace = "http://www.w3.org/2000/09/xmldsig#")]
    public IRMarkReceiptSignatureKeyInfo KeyInfo { get; set; }
    }

  //-----------------------------------------------------------------------------------------------
  // NOTE: The full content of this is not fully defined as we don't use it.
  [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.w3.org/2000/09/xmldsig#")]
  public class IRmarkReceiptSignatureSignedInfo
    {
    [XmlElement(ElementName="CanonicalizationMethod", Namespace = "http://www.w3.org/2000/09/xmldsig#")]
    public string CanonicalizationMethod {get; set;}

    [XmlElement(ElementName = "SignatureMethod", Namespace = "http://www.w3.org/2000/09/xmldsig#")]
    public string SignatureMethod { get; set; }

    [XmlElement(ElementName = "Reference", Namespace = "http://www.w3.org/2000/09/xmldsig#")]
    public IRmarkReceiptSignatureSignedInfoReference Reference { get; set; }
    }

  //-----------------------------------------------------------------------------------------------
  [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.w3.org/2000/09/xmldsig#")]
  public class IRmarkReceiptSignatureSignedInfoReference
    {
    [XmlArray("Transforms"), XmlArrayItem(typeof(IRMarkTransform), ElementName = "Key", Namespace = "http://www.w3.org/2000/09/xmldsig#")]
    public List<IRMarkTransform> Transforms { get; set; }

    [XmlElement(ElementName = "DigestMethod", Namespace = "http://www.w3.org/2000/09/xmldsig#")]
    public string DigestMethod { get; set; }

    [XmlElement(ElementName = "DigestValue", Namespace = "http://www.w3.org/2000/09/xmldsig#")]
    public string DigestValue { get; set; }
    }

  //-----------------------------------------------------------------------------------------------
  [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.w3.org/2000/09/xmldsig#")]
  public class IRMarkTransform
    {
    [XmlElement(ElementName = "Transform", Namespace = "http://www.w3.org/2000/09/xmldsig#")]
    public IRMarkReceiptTransform Transform { get; set; }
    }

  //-----------------------------------------------------------------------------------------------
  [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.w3.org/2000/09/xmldsig#")]
  public class IRMarkReceiptTransform
    {
    [XmlAttribute(AttributeName="Algorithm", Namespace = "http://www.w3.org/2000/09/xmldsig#")]
    public string Algorithm;

    [XmlElement(ElementName = "XPath", Namespace = "http://www.w3.org/2000/09/xmldsig#")]
    public string XPath { get; set; }
    }

  //-----------------------------------------------------------------------------------------------
  // NOTE: The full content of this is not fully defined as we don't use it.
  [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.w3.org/2000/09/xmldsig#")]
  public class IRMarkReceiptSignatureKeyInfo
    {
    [XmlElement(ElementName = "X509Data", Namespace = "http://www.w3.org/2000/09/xmldsig#")]
    public string X509Data { get; set; }
    }

  //-----------------------------------------------------------------------------------------------
  [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true)]
  public class BodySuccessResponseResponseData
    {
    [XmlElement(ElementName = "VATDeclarationResponse", Namespace = "http://www.govtalk.gov.uk/taxation/vat/vatdeclaration/2")]
    public BodySuccessResponseResponseDataVATDecResponse VATDeclarationResponse { get; set; }
    }

  //-----------------------------------------------------------------------------------------------
  [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true)]
  public class BodySuccessResponseResponseDataVATDecResponse
    {
    [XmlElement(ElementName="Header")]
    public BodySuccessResponseResponseDataVATDecResponseHeader Header { get; set; }

    [XmlElement(ElementName="Body")]
    public BodySuccessResponseResponseDataVATDecResponseBody Body {get; set;}
    }

  //-----------------------------------------------------------------------------------------------
  [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.govtalk.gov.uk/taxation/vat/vatdeclaration/2")]
  public class BodySuccessResponseResponseDataVATDecResponseHeader
    {
    [XmlElement(ElementName = "VATPeriod")]
    public BodySuccessResponseResponseDataVATDecResponseHeaderVATPeriod VATPeriod { get; set; }

    [XmlElement(ElementName = "CurrencyCode")]
    public string CurrencyCode { get; set; }
    }

  //-----------------------------------------------------------------------------------------------
  [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true)]
  public class BodySuccessResponseResponseDataVATDecResponseHeaderVATPeriod
    {
    [XmlElement(ElementName = "PeriodId")]
    public string PeriodId { get; set; }

    [XmlElement(ElementName = "PeriodStartDate")]
    public string PeriodStartDate { get; set; }

    [XmlElement(ElementName = "PeriodEndDate")]
    public string PeriodEndDate { get; set; }
    }


  //-----------------------------------------------------------------------------------------------
  [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.govtalk.gov.uk/taxation/vat/vatdeclaration/2")]
  public class BodySuccessResponseResponseDataVATDecResponseBody
    {
    [XmlElement(ElementName="PaymentDueDate")]
    public string PaymentDueDate {get; set;}

    [XmlElement(ElementName="VATDeclarationReference")]
    public string VATDeclarationReference {get; set;}

    [XmlElement(ElementName="ReceiptTimestamp")]
    public string ReceiptTimestamp {get; set;}

    [XmlElement(ElementName = "PaymentNotification")]
    public BodySuccessResponseResponseDataVATDecResponseBodyPaymentNotification PaymentNotification { get; set; }

    [XmlElement(ElementName = "InformationNotification")]
    public BodySuccessResponseResponseDataVATDecResponseBodyInformationNotification InformationNotification { get; set; }
    }

  //-----------------------------------------------------------------------------------------------
  [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true)]
  public class BodySuccessResponseResponseDataVATDecResponseBodyPaymentNotification
    {
    [XmlElement(ElementName = "Narrative")]
    public string Narrative { get; set; }

    [XmlElement(ElementName = "NetVAT")]
    public double NetVAT { get; set; }

    [XmlElement(ElementName="NilPaymentIndicator")]
    public string NilPaymentIndicator { get; set; }
    }

  //-----------------------------------------------------------------------------------------------
  [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true)]
  public class BodySuccessResponseResponseDataVATDecResponseBodyInformationNotification
    {
    [XmlElement(ElementName = "Narrative")]
    public string Narrative { get; set; }
    }
  }


