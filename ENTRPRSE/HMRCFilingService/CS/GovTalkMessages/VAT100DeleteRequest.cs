using System;
using System.Web;
using System.Xml;
using System.Xml.Serialization;
using System.Collections.Generic;

namespace HMRCFilingService.GovTalkMessages
  {
  //=================================================================================================  
  // VAT 100 Delete Request
  //=================================================================================================  
  [Serializable, XmlRoot(ElementName = "GovTalkMessage", Namespace = "http://www.govtalk.gov.uk/CM/envelope")]
  public class VAT100_DeleteRequest
    {
    [XmlElement(ElementName = "EnvelopeVersion")]
    public string EnvelopeVersion { get; set; }

    [XmlElement(ElementName = "Header")]
    public GovTalkMessage_Delete_Header Header { get; set; }

    [XmlElement(ElementName = "GovTalkDetails")]
    public GovTalkMessage_GovTalkDetails GovTalkDetails { get; set; }

    [XmlElement(ElementName = "Body")]
    public string Body { get; set; }

    /// <summary>
    /// Constructor
    /// </summary>
    public VAT100_DeleteRequest()
      {
      EnvelopeVersion = "2.0";
      // Create the sub-structures
      Header = new GovTalkMessage_Delete_Header();
      GovTalkDetails = new GovTalkMessage_GovTalkDetails();
      Body = string.Empty;

      Header.MessageDetails.Qualifier = "request";
      Header.MessageDetails.Function = "delete";
      Header.MessageDetails.Transformation = "XML";
      }
    }

  //=================================================================================================
  // GovTalkMessage/Header
  //=================================================================================================
  [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.govtalk.gov.uk/CM/envelope")]
  public class GovTalkMessage_Delete_Header
    {
    [XmlElement(ElementName = "MessageDetails")]
    public GovTalkMessage_Header_MessageDetails MessageDetails { get; set; }

    /// <summary>
    /// Constructor
    /// </summary>
    public GovTalkMessage_Delete_Header()
      {
      MessageDetails = new GovTalkMessage_Header_MessageDetails();
      }
    }

  }