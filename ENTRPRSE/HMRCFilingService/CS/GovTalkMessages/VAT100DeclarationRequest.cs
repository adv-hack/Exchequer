using System;
using System.Collections.Generic;
using System.Xml;
using System.Xml.Serialization;

namespace HMRCFilingService.GovTalkMessages
  {
  //=================================================================================================
  // VAT 100 Submission Request
  //=================================================================================================
  [Serializable, XmlRoot(ElementName = "GovTalkMessage", Namespace = "http://www.govtalk.gov.uk/CM/envelope")]
  public class VAT100_GovTalkMessage
    {
    [XmlElement(ElementName = "EnvelopeVersion")]
    public string EnvelopeVersion { get; set; }

    [XmlElement(ElementName = "Header")]
    public GovTalkMessage_Header Header { get; set; }

    [XmlElement(ElementName = "GovTalkDetails")]
    public GovTalkMessage_GovTalkDetails GovTalkDetails { get; set; }

    [XmlElement(ElementName = "Body")]
    public VAT100_GovTalkMessage_Body Body { get; set; }

    public VAT100_GovTalkMessage()
      {
      EnvelopeVersion = "2.0";
      }
    }

  //=================================================================================================
  // VAT100 GovTalkMessage Body
  //=================================================================================================
  [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.govtalk.gov.uk/CM/envelope")]
  public class VAT100_GovTalkMessage_Body
    {
    [XmlElement(ElementName = "IRenvelope", Namespace = "http://www.govtalk.gov.uk/taxation/vat/vatdeclaration/2")]
    public VAT100_IRenvelope IRenvelope { get; set; }
    }

  //=================================================================================================
  // VAT100 IRenvelope
  //=================================================================================================
  [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.govtalk.gov.uk/taxation/vat/vatdeclaration/2")]
  public class VAT100_IRenvelope
    {
    [XmlElement(ElementName = "IRheader", Namespace = "http://www.govtalk.gov.uk/taxation/vat/vatdeclaration/2")]
    public VAT100_IRenvelope_IRheader IRheader { get; set; }

    [XmlElement(ElementName = "VATDeclarationRequest", Namespace = "http://www.govtalk.gov.uk/taxation/vat/vatdeclaration/2")]
    public VAT100_IRenvelope_VATDeclarationRequest VATDeclarationRequest { get; set; }
    }

  //=================================================================================================
  // VAT100 IRenvelope
  //=================================================================================================
  [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.govtalk.gov.uk/taxation/vat/vatdeclaration/2")]
  public class VAT100_IRenvelope_IRheader
    {
    [XmlArray(ElementName = "Keys", Namespace = "http://www.govtalk.gov.uk/taxation/vat/vatdeclaration/2"),
          XmlArrayItem(typeof(GovTalkMessage_GovTalkDetails_Keys_Key), ElementName = "Key", Namespace = "http://www.govtalk.gov.uk/taxation/vat/vatdeclaration/2")]
    public List<GovTalkMessage_GovTalkDetails_Keys_Key> Keys { get; set; }

    [XmlElement(ElementName = "PeriodID", Namespace = "http://www.govtalk.gov.uk/taxation/vat/vatdeclaration/2")]
    public string PeriodID { get; set; }

    [XmlElement(ElementName = "IRmark", Namespace = "http://www.govtalk.gov.uk/taxation/vat/vatdeclaration/2")]
    //    public VAT100_IRenvelope_IRheader_IRmark IRmark { get; set; }
    public VAT100_IRenvelope_IRheader_IRmark IRMark { get; set; }

    [XmlElement(ElementName = "Sender", Namespace = "http://www.govtalk.gov.uk/taxation/vat/vatdeclaration/2")]
    public IRheaderSender Sender { get; set; }
    }

  //=================================================================================================
  // VAT100 IRenvelope IRheader IRmark
  //=================================================================================================
  [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.govtalk.gov.uk/taxation/vat/vatdeclaration/2")]
  public class VAT100_IRenvelope_IRheader_IRmark
    {
    [XmlAttribute(AttributeName = "Type")]
    public string Type { get; set; }

    [XmlText]
    public string Value { get; set; }
    }

  //=================================================================================================
  // VAT100 IRenvelope VATDeclarationRequest
  //=================================================================================================
  [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.govtalk.gov.uk/taxation/vat/vatdeclaration/2")]
  public class VAT100_IRenvelope_VATDeclarationRequest
    {
    [XmlElement(ElementName = "VATDueOnOutputs", Namespace = "http://www.govtalk.gov.uk/taxation/vat/vatdeclaration/2")]
    public double VATDueOnOutputs { get; set; }

    [XmlElement(ElementName = "VATDueOnECAcquisitions", Namespace = "http://www.govtalk.gov.uk/taxation/vat/vatdeclaration/2")]
    public double VATDueOnECAcquisitions { get; set; }

    [XmlElement(ElementName = "TotalVAT", Namespace = "http://www.govtalk.gov.uk/taxation/vat/vatdeclaration/2")]
    public double TotalVAT { get; set; }

    [XmlElement(ElementName = "VATReclaimedOnInputs", Namespace = "http://www.govtalk.gov.uk/taxation/vat/vatdeclaration/2")]
    public double VATReclaimedOnInputs { get; set; }

    [XmlElement(ElementName = "NetVAT", Namespace = "http://www.govtalk.gov.uk/taxation/vat/vatdeclaration/2")]
    public double NetVAT { get; set; }

    [XmlElement(ElementName = "NetSalesAndOutputs", Namespace = "http://www.govtalk.gov.uk/taxation/vat/vatdeclaration/2")]
    public int NetSalesAndOutputs { get; set; }

    [XmlElement(ElementName = "NetPurchasesAndInputs", Namespace = "http://www.govtalk.gov.uk/taxation/vat/vatdeclaration/2")]
    public int NetPurchasesAndInputs { get; set; }

    [XmlElement(ElementName = "NetECSupplies", Namespace = "http://www.govtalk.gov.uk/taxation/vat/vatdeclaration/2")]
    public int NetECSupplies { get; set; }

    [XmlElement(ElementName = "NetECAcquisitions", Namespace = "http://www.govtalk.gov.uk/taxation/vat/vatdeclaration/2")]
    public int NetECAcquisitions { get; set; }
    }

  //=================================================================================================
  // Enumerated types
  //=================================================================================================
  // WorkHomeType
  //=================================================================================================
  [System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "4.0.30319.1")]
  [System.SerializableAttribute()]
  [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.govtalk.gov.uk/taxation/vat/vatdeclaration/2")]
  public enum VATDeclarationRequestFinalReturn
    {
    yes,
    }
  }