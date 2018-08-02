using System;
using System.Web;
using System.Xml;
using System.Xml.Serialization;
using System.Collections.Generic;

namespace HMRCFilingService.GovTalkMessages
  {
  [Serializable, XmlRoot(ElementName = "GovTalkMessage", Namespace = "http://www.govtalk.gov.uk/CM/envelope")]
  public class VAT100_Acknowledgement
    {
    [XmlElement(ElementName = "EnvelopeVersion")]
    public string EnvelopeVersion { get; set; }

    [XmlElement(ElementName = "Header")]
    public GovTalkMessage_Header Header { get; set; }

    [XmlElement(ElementName = "GovTalkDetails")]
    public GovTalkMessage_GovTalkDetails GovTalkDetails { get; set; }

    [XmlElement(ElementName = "Body")]
    public string Body { get; set; }

    public VAT100_Acknowledgement()
      {
      EnvelopeVersion = "2.0";
      }
    }
  }