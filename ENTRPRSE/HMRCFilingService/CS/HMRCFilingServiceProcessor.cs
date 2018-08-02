using System;
using System.IO;
using System.Net;
using System.Net.Sockets;
using System.Text;
//using System.Windows.Forms;
using System.Xml;
using System.Collections.Generic;
using System.Xml.Serialization;
using HMRCFilingService.GovTalkMessages;
using Enterprise04;
using EnterpriseBeta;
using System.Reflection;

namespace HMRCFilingService
  {
  public class HMRCFilingServiceProcessor : IHMRCFilingService
    {
    private static string FErrorString = string.Empty;
	//HV 14/05/2018 2018-R1.1 ABSEXCH-20505 : VAT100 : New Live URL From XML
    public const string HMRC_LIVE_URL = @"https://transaction-engine.tax.service.gov.uk/submission";
    public const string HMRC_DEV_URL = @"https://test-transaction-engine.tax.service.gov.uk/submission";
    public const string MESSAGE_CLASS_VAT_RETURN = "HMRC-VAT-DEC";

    // TIL (Test-In-Live) class added to allow test submissions to the live site.
    public const string MESSAGE_CLASS_VAT_RETURN_TIL = "HMRC-VAT-DEC-TIL";

    // Database handler
    private VAT100Database dbHandler = null;

    // HMRC Response handler
    private PollingService FPollingService = null;

    private string FCorrelationID = string.Empty;

    private string FDocType;
    private string FXMLDoc;
    private string FDocClass;

    string thisPath;

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Constructor
    /// </summary>
    public HMRCFilingServiceProcessor()
      {
      thisPath = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);

      // Create a database handler
      dbHandler = VAT100Database.Instance;

      // For now, direct all logging to the main Exchequer directory
      Log.Path = dbHandler.tToolkit.Configuration.EnterpriseDirectory;
      Log.Add("HMRC Filing Service started");

      // Create a Response Handler
      FPollingService = PollingService.Instance;

      SetWebServiceURL();
      }

    /// <summary>
    /// Determines the IP address for this machine and stores it in an INIfile
    /// so that it is available to any instances of Exchequer which need to
    /// access the web-service.
    /// </summary>
    private void SetWebServiceURL()
      {
      IPHostEntry host;
      string localIP = "?";
      host = Dns.GetHostEntry(Dns.GetHostName());
      foreach (IPAddress ip in host.AddressList)
        {
        if (ip.AddressFamily == AddressFamily.InterNetwork)
          {
          localIP = ip.ToString();
          }
        }
      string filespec = dbHandler.tToolkit.Configuration.EnterpriseDirectory + @"HMRC Filing Service\HMRCFiling.ini";
      // WriteAllText creates a file, writes the specified string to the file, 
      // and then closes the file.
      try
        {
        Logger.Log(string.Format("[WebService]\r\nURL={0}", localIP));
        }
      catch
        {
        // Sink the error.  There's not much we can do about it, and it's not critical.
        Logger.Log("ServiceProcessor : Failed to save file, HMRCFiling.ini");
        }
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Submit an XML file to HMRC and adds it to the polling service to
    /// wait for a response. This method returns the immediate response,
    /// which will be an XML string containing either an acknowledgement
    /// that the submission was received by HMRC, or an error.
    /// </summary>
    /// <returns></returns>
    public string SubmitToHMRC(string companycode, string doctype, string xmldoc, string filename, string suburl, string username, string email)
      {
      string Result = string.Empty;

      Console.WriteLine("");
      Console.WriteLine("SubmitToHMRC request");

      Log.Add("SubmitToHMRC request received for company " + companycode);

      // Can only accept a submission if none are in progress for this company.
      if (FPollingService.Status(companycode) == ServiceStatus.ssIdle)
        {
        // Add the IRMark
        xmldoc = ApplyIRMark(xmldoc);

        // CJS 2015-09-24 - ABSEXCH-16922 - HMRC Filing VAT Submissions xml folder
        // Save a copy of the submitted file
        XMLWrite.ToSentFolder(dbHandler.tToolkit.Configuration.EnterpriseDirectory, filename, xmldoc);

        // Store the parameters locally in the pending document
        FDocType = doctype;
        FXMLDoc = xmldoc;

        //...........................................................................................
        // Prepare for the submission
        string hmrcURL = string.Empty;

        if (string.IsNullOrEmpty(username))
          {
          username = "Exchequer User";
          }

        // Deserialize the XML to an hierarchical class structure so we can save the details
        VAT100_GovTalkMessage outMessage = DeserializeFromXmlString<VAT100_GovTalkMessage>(xmldoc);

        // Save the message class (HMRC-VAT-DEC or HMRC-VAT-DEC-TIL)
        FDocClass = outMessage.Header.MessageDetails.Class;

        // Determine where we want to send the data (Live or Dev)
        // The message class (HMRC-VAT-DEC or HMRC-VAT-DEC-TIL) will already be in the message sent by Exchequer.
        hmrcURL = suburl;

        //...........................................................................................
        // Submit the XML to HMRC and await the acknowledgement response

        // Create a request
        var request = (HttpWebRequest)WebRequest.Create(hmrcURL);
        var data = Encoding.ASCII.GetBytes(xmldoc);
        string responseXML = string.Empty;

        //        LogText(PrettyPrinter.PrettyPrintXML(XMLDoc));

        request.Method = "POST";
        request.ContentType = "application/x-www-form-urlencoded";
        request.ContentLength = data.Length;

        // Write the data to the request parameters
        using (var stream = request.GetRequestStream())
          {
          stream.Write(data, 0, data.Length);
          }

//        Log.Add("Submitting request to " + hmrcURL);
//        Console.WriteLine("Submitting request to " + hmrcURL);

        // Send the request and get the response.
        var response = (HttpWebResponse)request.GetResponse();

        // Get the response in a stream.
        var responseData = new StreamReader(response.GetResponseStream()).ReadToEnd();

        // Convert the stream to a string
        responseXML = responseData.ToString();
        //        LogText(PrettyPrinter.PrettyPrintXML(responseXML));

        //      Clipboard.SetData(System.Windows.Forms.DataFormats.Text, responseXML);

        // Deserialise the response
        VAT100_Acknowledgement acknowledgementMsg;

        XmlSerializer serialiser = new XmlSerializer(typeof(VAT100_Acknowledgement));
        using (StringReader reader = new StringReader(responseXML))
          {
          acknowledgementMsg = (VAT100_Acknowledgement)(serialiser.Deserialize(reader));
          }

        //...........................................................................................
        // Determine the response type.
        // For a successful submission, this will be "acknowledgement"
        // For a submission failure, this will be "error"
        string responseType = acknowledgementMsg.Header.MessageDetails.Qualifier;

        switch (responseType.ToLower())
          {
          case "acknowledgement":
            Log.Add("Acknowledgement received");
            FPollingService.Add(companycode, doctype, username, outMessage, acknowledgementMsg);
            break;

          case "error":
            Log.Add("Error response received from HMRC");
            break;

          default:
            Log.Add("Unrecognised response from HMRC");
            // Unrecognised response qualifier
            break;
          }

        Result = responseXML;
        }
      else
        {
        // Tried to submit a return while one is in progress.
        FErrorString = "A VAT 100 return submission is currently being processed";
        Log.Add(FErrorString);
        Result = string.Empty;
        }
      return Result;
      }

    //---------------------------------------------------------------------------------------------
    public void LogText(string message)
      {
      Log.Add(message);
      }

    //---------------------------------------------------------------------------------------------
    public static T DeserializeFromXmlString<T>(string xmlString)
      {
      Byte[] bArray = Encoding.UTF8.GetBytes(xmlString);

      using (MemoryStream stream = new MemoryStream(bArray))
        {
        XmlSerializer serializer = new XmlSerializer(typeof(T), "http://www.govtalk.gov.uk/CM/envelope");
        return (T)serializer.Deserialize(stream);
        }
      }

    //---------------------------------------------------------------------------------------------
    private static byte[] GetBytes(string str)
      {
      byte[] bytes = new byte[str.Length * sizeof(char)];
      System.Buffer.BlockCopy(str.ToCharArray(), 0, bytes, 0, bytes.Length);
      return bytes;
      }

    //=============================================================================================
    public string GetLastErrorString()
      {
      string retStr = string.Format("{0}", FErrorString);
      FErrorString = string.Empty;
      return retStr;
      }

    //=============================================================================================
    /// <summary>
    /// Returns true if a return for the VAT Period has been submitted and is either pending or accepted
    /// Returns false if a return for the VAT Period has not been submitted, or it has error status.
    /// </summary>
    /// <param name="aVatPeriod"></param>
    /// <returns></returns>
    public bool ReturnSubmittedFor(string vatper, string ForCompanyCode)
      {
      Console.WriteLine("");
      Console.WriteLine(string.Format("ReturnSubmittedFor({0}) request", vatper));

      bool Result = false;

      try
        {
        FErrorString = string.Empty;

        IVAT100 oVATReturn = VAT100Database.Instance.GetRecordByVATPeriod(vatper, ForCompanyCode);

        if (oVATReturn != null)
          {
          Result = true;
          // If the status is error, we can resubmit
          if (oVATReturn.vatStatus == 3)
            {
            Result = false;
            }
          }
        }
      catch (Exception Ex)
        {
        FErrorString = Ex.Message;
        Result = false;
        }

      return Result;
      }

    //=============================================================================================
    public string TimeAndDate()
      {
      Console.WriteLine("");
      Console.WriteLine("TimeAndDate request");
      string timeNow = DateTime.Now.ToString();
      return "The time is " + timeNow;
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Applies an IRMark to the supplied XML
    /// </summary>
    /// <param name="doc"></param>
    /// <returns></returns>
    public string ApplyIRMark(string doc)
      {
      Console.WriteLine("");
      Console.WriteLine("IRMark request");

      // Get a local copy of the document
      string Result = doc;

      // Apply the IRMark.
      IRMark32.AddIRMark(ref Result, "http://www.govtalk.gov.uk/taxation/vat/vatdeclaration/2");

      // Send it back.
      return Result;
      }

    //---------------------------------------------------------------------------------------------
    // Input string is in this format: 2013-07-16T14:18:08.539
    public static string ConvertHMRCDateStamp(string timeStamp)
      {
      string Result;
      string year, month, day, hour, min, sec;

      year = timeStamp.Substring(0, 4);
      month = timeStamp.Substring(5, 2);
      day = timeStamp.Substring(8, 2);
      hour = timeStamp.Substring(11, 2);
      min = timeStamp.Substring(14, 2);
      sec = timeStamp.Substring(17, 2);
      // Note: Ignoring the number of milliseconds in the timestamp.

      Result = string.Format("{0:2}/{1:2}/{2:2} {3:2}:{4:2}:{5:2}", year, month, day, hour, min, sec);
      return Result;
      }

    }
  }
