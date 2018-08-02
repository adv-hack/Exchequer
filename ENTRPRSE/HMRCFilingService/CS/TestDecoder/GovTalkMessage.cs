using System;
using System.Collections.Generic;
using System.Xml;
using System.Xml.Serialization;

// Contains definitions of XML elements that are common to all GovTalk messages, so they can be
// reused for defining multiple documents.

namespace HMRCFilingService.GovTalkMessages
  {
  //=================================================================================================
  // GovTalkMessage/Header
  //=================================================================================================
  [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.govtalk.gov.uk/CM/envelope")]
  public class GovTalkMessage_Header
    {
    [XmlElement(ElementName = "MessageDetails")]
    public GovTalkMessage_Header_MessageDetails MessageDetails { get; set; }

    [XmlElement(ElementName = "SenderDetails")]
    public GovTalkMessage_Header_SenderDetails SenderDetails { get; set; }

    /// <summary>
    /// Constructor
    /// </summary>
    public GovTalkMessage_Header()
      {
      MessageDetails = new GovTalkMessage_Header_MessageDetails();
      SenderDetails = new GovTalkMessage_Header_SenderDetails();
      }
    }

  //===============================================================================================
  // GovTalkMessage/Header/MessageDetails
  //===============================================================================================
  [Serializable, XmlRoot(ElementName = "MessageDetails")]
  public class GovTalkMessage_Header_MessageDetails
    {
    [XmlElement(ElementName = "Class")]
    public string Class { get; set; }

    [XmlElement(ElementName = "Qualifier")]
    public string Qualifier { get; set; }

    [XmlElement(ElementName = "Function")]
    public string Function { get; set; }

    [XmlElement(ElementName = "TransactionID")]
    public string TransactionID { get; set; }

    [XmlElement(ElementName = "CorrelationID")]
    public string CorrelationID { get; set; }

    [XmlElement(ElementName = "ResponseEndPoint")]
    public GovTalkMessage_Header_MessageDetails_ResponseEndPoint ResponseEndPoint { get; set; }

    [XmlElement(ElementName = "Transformation")]
    public string Transformation { get; set; }

    // This element is optional, but must be set if it's present.  Omitted because we never use it.
    //    [XmlElement(ElementName = "GatewayTest")]
    //    public int GatewayTest { get; set; }

    [XmlElement(ElementName = "GatewayTimestamp")]
    public string GatewayTimestamp { get; set; }
    }

  //=================================================================================================
  // GovTalkMessage/Header/MessageDetail/ResponseEndPoint
  //=================================================================================================
  [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.govtalk.gov.uk/CM/envelope")]
  public class GovTalkMessage_Header_MessageDetails_ResponseEndPoint
    {
    [XmlAttribute(AttributeName = "PollInterval")]
    public int PollInterval { get; set; }

    [XmlText]
    public string EndPoint { get; set; }
    }

  //===============================================================================================
  // GovTalkMessage/Header/SenderDetails
  //===============================================================================================
  [Serializable, XmlRoot(ElementName = "SenderDetails")]
  public class GovTalkMessage_Header_SenderDetails
    {
    [XmlElement(ElementName = "IDAuthentication")]
    public GovTalkMessage_Header_SenderDetails_IDAuthentication IDAuthentication { get; set; }

    /// <summary>
    /// Constructor
    /// </summary>
    public GovTalkMessage_Header_SenderDetails()
      {
      IDAuthentication = new GovTalkMessage_Header_SenderDetails_IDAuthentication();
      }
    }

  //===============================================================================================
  // GovTalkMessage/Header/SenderDetails/IDAuthentication
  //===============================================================================================
  [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.govtalk.gov.uk/CM/envelope")]
  public class GovTalkMessage_Header_SenderDetails_IDAuthentication
    {
    [XmlElement(ElementName = "SenderID")]
    public string senderID { get; set; }

    [XmlElement(ElementName = "Authentication")]
    public GovTalkMessage_Header_SenderDetails_IDAuthentication_Authentication Authentication { get; set; }

    /// <summary>
    /// Constructor
    /// </summary>
    public GovTalkMessage_Header_SenderDetails_IDAuthentication()
      {
      Authentication = new GovTalkMessage_Header_SenderDetails_IDAuthentication_Authentication();
      }
    }

  //===============================================================================================
  // GovTalkMessage/Header/SenderDetails/IDAuthentication/Authentication
  //===============================================================================================
  [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.govtalk.gov.uk/CM/envelope")]
  public class GovTalkMessage_Header_SenderDetails_IDAuthentication_Authentication
    {
    [XmlElement(ElementName = "Method")]
    public string Method { get; set; }

    [XmlElement(ElementName = "Value")]
    public string Value { get; set; }
    }

  //=================================================================================================
  // GovTalkMessage/GovTalkDetails
  //=================================================================================================
  [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.govtalk.gov.uk/CM/envelope")]
  public class GovTalkMessage_GovTalkDetails
    {
    [XmlArray("Keys"), XmlArrayItem(typeof(GovTalkMessage_GovTalkDetails_Keys_Key), ElementName = "Key")]
    public List<GovTalkMessage_GovTalkDetails_Keys_Key> Keys { get; set; }

    [XmlElement(ElementName = "TargetDetails")]
    public GovTalkMessage_GovTalkDetails_TargetDetails TargetDetails { get; set; }

    [XmlElement(ElementName = "ChannelRouting")]
    public GovTalkMessage_GovTalkDetails_ChannelRouting ChannelRouting { get; set; }

    public GovTalkMessage_GovTalkDetails()
      {
      Keys = new List<GovTalkMessage_GovTalkDetails_Keys_Key>();
      }
    }

  //=================================================================================================
  // GovTalkMessage/GovTalkDetails/Keys
  //=================================================================================================
  [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.govtalk.gov.uk/CM/envelope")]
  public class GovTalkMessage_GovTalkDetails_Keys
    {
    public List<GovTalkMessage_GovTalkDetails_Keys_Key> Key { get; set; }
    }

  //=================================================================================================
  // GovTalkMessage/GovTalkDetails/Keys/Key
  //=================================================================================================
  [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.govtalk.gov.uk/CM/envelope")]
  public class GovTalkMessage_GovTalkDetails_Keys_Key
    {
    [XmlAttribute(AttributeName = "Type")]
    public string Type { get; set; }

    [XmlText]
    public string Value { get; set; }
    }

  //=================================================================================================
  // GovTalkMessage/GovTalkDetails/TargetDetails
  //=================================================================================================
  [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.govtalk.gov.uk/CM/envelope")]
  public class GovTalkMessage_GovTalkDetails_TargetDetails
    {
    [XmlElement(ElementName = "Organisation")]
    public string Organisation { get; set; }
    }

  //=================================================================================================
  // GovTalkMessage/GovTalkDetails/ChannelRouting
  //=================================================================================================
  [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.govtalk.gov.uk/CM/envelope")]
  public class GovTalkMessage_GovTalkDetails_ChannelRouting
    {
    [XmlElement(ElementName = "Channel")]
    public GovTalkMessage_GovTalkDetails_ChannelRouting_Channel Channel { get; set; }
    }

  //=================================================================================================
  // GovTalkMessage/GovTalkDetails/ChannelRouting/Channel
  //=================================================================================================
  [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.govtalk.gov.uk/CM/envelope")]
  public class GovTalkMessage_GovTalkDetails_ChannelRouting_Channel
    {
    [XmlElement(ElementName = "URI")]
    public short uRIField { get; set; }

    [XmlElement(ElementName = "Product")]
    public string productField { get; set; }

    [XmlElement(ElementName = "Version")]
    public string versionField { get; set; }
    }

  //=================================================================================================
  // Enumerated types
  //=================================================================================================
  // IRHeader Sender
  //=================================================================================================
  [System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "4.0.30319.1")]
  [System.SerializableAttribute()]
  [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.govtalk.gov.uk/taxation/vat/vatdeclaration/2")]
  public enum IRheaderSender
    {
    Individual,
    Company,
    Agent,
    Bureau,
    Partnership,
    Trust,
    Employer,
    Government,

    [System.Xml.Serialization.XmlEnumAttribute("Acting in Capacity")]
    ActinginCapacity,

    Other,
    }

  //=================================================================================================
  // WorkHomeType
  //=================================================================================================
  [System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "4.0.30319.1")]
  [System.SerializableAttribute()]
  [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://www.govtalk.gov.uk/taxation/vat/vatdeclaration/2")]
  public enum WorkHomeType
    {
    home,
    work,
    }

  //=================================================================================================
  // IRheader IRmarkType
  //=================================================================================================
  [System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "4.0.30319.1")]
  [System.SerializableAttribute()]
  [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.govtalk.gov.uk/taxation/vat/vatdeclaration/2")]
  public enum IRheaderIIRmarkType
    {
    generic,
    }

  //=================================================================================================
  // IRheader DefaultCurrency
  //=================================================================================================
  [System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "4.0.30319.1")]
  [System.SerializableAttribute()]
  [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.govtalk.gov.uk/taxation/vat/vatdeclaration/2")]
  public enum IRheader_DefaultCurrency
    {
    GBP,
    }

  //=================================================================================================
  // YesNoType
  //=================================================================================================
  [System.CodeDom.Compiler.GeneratedCodeAttribute("xsd", "4.0.30319.1")]
  [System.SerializableAttribute()]
  [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://www.govtalk.gov.uk/taxation/vat/vatdeclaration/2")]
  public enum YesNoType
    {
    no,
    yes,
    }
  }