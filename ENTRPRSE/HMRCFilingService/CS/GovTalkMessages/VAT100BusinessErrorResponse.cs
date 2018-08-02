using System;
using System.Web;
using System.Xml;
using System.Xml.Serialization;
using System.Collections.Generic;


namespace HMRCFilingService.GovTalkMessages
  {
  //=================================================================================================  
  // VAT 100 Submission Error
  //=================================================================================================  
  [Serializable, XmlRoot(ElementName = "GovTalkMessage", Namespace = "http://www.govtalk.gov.uk/CM/envelope")]
  public class VAT100_BusinessErrorResponse
    {
    [XmlElement(ElementName = "EnvelopeVersion")]
    public string EnvelopeVersion { get; set; }

    [XmlElement(ElementName = "Header")]
    public GovTalkMessage_Header Header { get; set; }

    [XmlElement(ElementName = "GovTalkDetails")]
    public VAT100BusinessResponseDetails GovTalkDetails { get; set; }

    [XmlElement(ElementName = "Body")]
    public VAT100_ErrorResponseBody Body { get; set; }

    public VAT100_BusinessErrorResponse()
      {
      EnvelopeVersion = "2.0";
      }
    }


  [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.govtalk.gov.uk/CM/errorresponse")]
  public class VAT100_ErrorResponseBody
    {
    [XmlElement(ElementName = "ErrorResponse", Namespace = "http://www.govtalk.gov.uk/CM/errorresponse")]
    public VAT100_ErrorResponse ErrorResponse { get; set; }

    }

  [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.govtalk.gov.uk/CM/errorresponse")]
  public class VAT100_ErrorResponse
    {
    [XmlElement(ElementName = "Application")]
    public VAT100_ErrorResponseApplication Application {get; set;}
    
    // A list of errors, without an enclosing element
    [XmlElement(ElementName = "Error")]
    public VAT100_ErrorResponseError[] ErrorList { get; set; }
    }


  [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.govtalk.gov.uk/CM/errorresponse")]
  public class VAT100_ErrorResponseApplication
    {
    [XmlElement(ElementName = "MessageCount")]
    public int MessageCount {get; set;}
    }

  [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true, Namespace = "http://www.govtalk.gov.uk/CM/errorresponse")]
  public class VAT100_ErrorResponseError
    {
    [XmlElement(ElementName = "RaisedBy")]
    public string RaisedBy {get; set;}

    [XmlElement(ElementName = "Number")]
    public int Number {get; set;}

    [XmlElement(ElementName = "Type")]
    public string Type {get; set;}

    [XmlElement(ElementName = "Text")]
    public string Text {get; set;}

    [XmlElement(ElementName = "Location")]
    public string Location { get; set;}
    }
  }