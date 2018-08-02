using System.ComponentModel;
using System.ServiceModel;
using System.ServiceModel.Web;


namespace HMRCFilingService
  {
  [ServiceContract]
  public interface IHMRCFilingService
    {
    [OperationContract]
    [Description("Submits a VAT100 return XML file to HMRC using HTTP GET")]
    [WebGet]
    string SubmitToHMRC(string companyCode, string doctype, string xmldoc, string filename, string suburl, string username, string email);

    [OperationContract]
    [Description("Gets the last error string using HTTP GET")]
    [WebGet]
    string GetLastErrorString();

    [OperationContract]
    [Description("Determines if a VAT return has been sent for a VAT period using HTTP GET")]
    [WebGet(UriTemplate = "ReturnSubmittedFor?vatper={vatper}&companycode={companycode}")]
    bool ReturnSubmittedFor(string vatper, string companycode);

    [OperationContract]
    [Description("Provides a convenient way of testing the service")]
    [WebGet]
    string TimeAndDate();

    // NOTE: No Data Contracts are required for this interface because only simple types (strings, integers) are used.
    }
  }
