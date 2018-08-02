using System;
using System.Web;
using System.Xml;
using System.Xml.Serialization;
using System.Collections.Generic;

namespace HMRCFilingService.GovTalkMessages
  {
  //=================================================================================================  
  // VAT 100 Poll - Contains only Mandatory fields
  //=================================================================================================  
  [Serializable, XmlRoot(ElementName = "GovTalkMessage", Namespace = "http://www.govtalk.gov.uk/CM/envelope")]
  public class VAT100_Poll
    {
    [XmlElement(ElementName = "EnvelopeVersion")]
    public string EnvelopeVersion { get; set; }

    [XmlElement(ElementName = "Header")]
    public GovTalkMessage_Header_Poll Header { get; set; }

    [XmlElement(ElementName = "GovTalkDetails")]
    public GovTalkMessage_GovTalkDetails GovTalkDetails { get; set; }

    /// <summary>
    /// Constructor
    /// </summary>
    public VAT100_Poll()
      {
      EnvelopeVersion = "2.0";
      Header = new GovTalkMessage_Header_Poll();
      GovTalkDetails = new GovTalkMessage_GovTalkDetails();
      }
    }

  //=================================================================================================  
  // GovTalkMessage/Header
  //=================================================================================================  
  [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.govtalk.gov.uk/CM/envelope")]
  public class GovTalkMessage_Header_Poll
    {
    [XmlElement(ElementName = "MessageDetails")]
    public GovTalkMessage_Header_MessageDetails_Poll MessageDetails { get; set; }

    public GovTalkMessage_Header_Poll()
      {
      MessageDetails = new GovTalkMessage_Header_MessageDetails_Poll();
      }
    }

  //===============================================================================================  
  // GovTalkMessage/Header/MessageDetails
  //===============================================================================================  
  [Serializable, XmlRoot(ElementName = "MessageDetails")]
  public class GovTalkMessage_Header_MessageDetails_Poll
    {
    [XmlElement(ElementName = "Class")]
    public string Class { get; set; }

    [XmlElement(ElementName = "Qualifier")]
    public string Qualifier { get; set; }

    [XmlElement(ElementName = "Function")]
    public string Function { get; set; }

    [XmlElement(ElementName = "CorrelationID")]
    public string CorrelationID { get; set; }

    [XmlElement(ElementName = "Transformation")]
    public string Transformation { get; set; }

    public GovTalkMessage_Header_MessageDetails_Poll()
      {
      Class = "";
      Qualifier = "poll";
      Function = "submit";
      CorrelationID = "";
      Transformation = "XML";
      }
    }

  }

