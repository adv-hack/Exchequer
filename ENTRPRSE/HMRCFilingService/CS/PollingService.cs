using System;
using System.IO;
using System.Net;
using System.Text;
using System.Timers;
using System.Xml;
using System.Xml.Serialization;
using EnterpriseBeta;
using HMRCFilingService.GovTalkMessages;

namespace HMRCFilingService
  {
  //-----------------------------------------------------------------------------------------------
  /// <summary>
  /// Class to poll the HMRC Gateway for submission statuses. Using a list
  /// of submissions (maintained by the PendingDocuments class) it cycles
  /// through each submission in turn and calls the HMRC web-service to 
  /// retrieve any waiting response for the submission, updating the VAT100 
  /// database once a response is received.
  /// 
  /// New submissions can be added to the list at any time, via the Add() 
  /// method (this is called from HMRCFilingService.SubmitToHMRC when a
  /// new submission is received).
  /// </summary>
  public class PollingService
    {
    private const int DEFAULT_POLLING_INTERVAL = 1000;  // 10 * 60 * 1000; // 10 minutes
    private const int SECONDS_TO_TIMER_INTERVAL_MULTIPLIER = 1000;

    private static PollingService instance;

    private string destURL = string.Empty;

    private System.Timers.Timer pollingTimer;

    private DocumentRecord FPendingDocument;

    private VAT100Database FDatabase;

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// private Constructor for internal use only
    /// </summary>
    private PollingService()
      {
      FDatabase = VAT100Database.Instance;

      pollingTimer = new System.Timers.Timer();
      StopPolling();
      pollingTimer.Interval = DEFAULT_POLLING_INTERVAL;

      pollingTimer.Elapsed += OnTimerElapsedEvent;

      FPendingDocument = SelectNextDocument();
      if (FPendingDocument != null)
        {
        PrepareHMRCRequest(FPendingDocument);
        }
      else
        {
        //        Log.Add("Polling Service ready, but no VAT submissions are pending");
        // Switch back to the default polling interval
        pollingTimer.Interval = DEFAULT_POLLING_INTERVAL;
        }

      // Documents could arrive at any time, so poll continuously
      StartPolling();
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Return the Singleton instance of the ResponsePoller
    /// </summary>
    public static PollingService Instance
      {
      get
        {
        if (instance == null)
          {
          // Doesn't exist, so create one
          instance = new PollingService();
          }
        return instance;
        }
      }

    /// <summary>
    /// Returns the current service status for the specified company. If there are no submissions
    /// against this company it will always return ssIdle.
    /// </summary>
    /// <param name="ForCompany"></param>
    /// <returns>ServiceStatus</returns>
    public ServiceStatus Status(string ForCompany)
      {
      // Return idle if no record found.
      ServiceStatus status = ServiceStatus.ssIdle;

      VAT100Record Entry = null;

      // PKR. 15/09/2015. ABSEXCH-16855. Status of a submission in one company is affecting other companies.
      // Get the record that is submitted or pending for this company.
      // If there isn't one, we get null back.
      Entry = FDatabase.GetPendingVAT100Entry(ForCompany);
      if (Entry != null)
        {
        status = (ServiceStatus)Entry.status;
        }

      /*
            // We don't need this.  We are looking only for the submission status for the specified company -
            // the one passed in - NOT for any company.

            Enterprise04.ICompanyDetail CompanyDetail;
            // Cycle through all the companies
            int CompanyCount = FDatabase.tToolkit.Company.cmCount;
            for (int i = 1; i <= CompanyCount; i++)
              {
              // Point the Toolkit at the company path (getPendingVAT100Entry will
              // open and close the Toolkit using this path)
              CompanyDetail = FDatabase.tToolkit.Company.get_cmCompany(i);

              // Find any pending VAT Submission for this company and add it to the list
              Entry = FDatabase.GetPendingVAT100Entry(CompanyDetail.coCode);
              if (Entry != null)
                {
                status = (ServiceStatus)Entry.status;
                }
              }
      */
      return status;
      }

    /// <summary>
    /// Adds a new VAT Return Submission to the VAT100 database table following receipt of an Acknowledgement.
    /// </summary>
    /// <param name="companyCode"></param>
    /// <param name="documentType"></param>
    /// <param name="userName"></param>
    /// <param name="request"></param>
    /// <param name="acknowledgement"></param>
    /// <returns></returns>
    public bool Add(string companyCode, string documentType, string userName, VAT100_GovTalkMessage request, VAT100_Acknowledgement acknowledgement)
      {
      // Create a Document for use by the Polling functions.
      DocumentRecord newDocument = new DocumentRecord();
      newDocument.theDocument = new VAT100Record();
      newDocument.companyCode = companyCode;
      newDocument.companyPath = FDatabase.GetCompanyPath(companyCode);

      // Fill in the details
      newDocument.theDocument.correlationID = acknowledgement.Header.MessageDetails.CorrelationID;
      newDocument.theDocument.IRMark = request.Body.IRenvelope.IRheader.IRMark.Value;
      DateTime timeNow = DateTime.Now;
      newDocument.theDocument.dateSubmitted = timeNow.ToString("ddMMyyyy HHmmss");
      newDocument.theDocument.documentType = documentType;
      newDocument.theDocument.VATPeriod = request.Body.IRenvelope.IRheader.PeriodID;
      newDocument.theDocument.username = userName;
      newDocument.theDocument.status = (short)SubmissionStatus.ssSubmitted;
      newDocument.theDocument.pollingInterval = acknowledgement.Header.MessageDetails.ResponseEndPoint.PollInterval;
      newDocument.theDocument.VATDueOnOutputs = request.Body.IRenvelope.VATDeclarationRequest.VATDueOnOutputs;
      newDocument.theDocument.VATDueOnECAcquisitions = request.Body.IRenvelope.VATDeclarationRequest.VATDueOnECAcquisitions;
      newDocument.theDocument.VATTotal = request.Body.IRenvelope.VATDeclarationRequest.TotalVAT;
      newDocument.theDocument.VATReclaimedOnInputs = request.Body.IRenvelope.VATDeclarationRequest.VATReclaimedOnInputs;
      newDocument.theDocument.VATNet = request.Body.IRenvelope.VATDeclarationRequest.NetVAT;
      newDocument.theDocument.netSalesAndOutputs = request.Body.IRenvelope.VATDeclarationRequest.NetSalesAndOutputs;
      newDocument.theDocument.netPurchasesAndInputs = request.Body.IRenvelope.VATDeclarationRequest.NetPurchasesAndInputs;
      newDocument.theDocument.netECSupplies = request.Body.IRenvelope.VATDeclarationRequest.NetECSupplies;
      newDocument.theDocument.netECAcquisitions = request.Body.IRenvelope.VATDeclarationRequest.NetECAcquisitions;

      // PKR. 16/09/2015. ABSEXCH-16865. Add a temporary narrative so that the Submission record isn't empty.
      newDocument.theDocument.hmrcNarrative = "Acknowledgement received from HMRC.";

      newDocument.theDocument.PollingURL = acknowledgement.Header.MessageDetails.ResponseEndPoint.EndPoint;

      // Save the pending document
      int Res = 0;

      // CJS 2016-06-06 - ABSEXCH-17494 - VAT submission returning HMRC message to wrong company.
      // If we are not polling, it probably means that we are searching for or processing
      // an existing document, in which case it is not safe to use the VAT100Database singleton,
      // because it is already being used and might be open in the wrong company. Instead use
      // a new instance.
      if (!pollingTimer.Enabled)
        {
          Res = VAT100Database.GetNewInstance().AddVAT100Entry(newDocument.theDocument, companyCode);
        }
      else
        {
          Res = VAT100Database.Instance.AddVAT100Entry(newDocument.theDocument, companyCode);
        }
      if (Res != 0)
        {
        Log.Add(string.Format("Failed to save pending document for {0}. Error code : {1}", companyCode, Res));
        return false;
        }
      else
        {
        return true;
        }
      }

    /// <summary>
    /// Processes the currently selected document, if any, then selects
    /// the next document. This is the central polling routine, and is
    /// called from the timer event at regular intervals, so that all
    /// pending documents are cycled through one at a time.
    /// </summary>
    private int ProcessPendingDocument()
      {
      // Need to send a poll message to HMRC for the current pending submission
      // The message has all its fixed fields populated automatically.
      // We just have to set:
      // 1) Class
      // 2) CorrelationID

      int Result = 0;

      // Stop polling while we send a polling message so that we can't possibly re-enter (especially while debugging)
      // Poll timimg is not critical and the user won't see it happening.
      StopPolling();

      try
        {
        // Ensure that we have a document to work with
        if (FPendingDocument != null)
          {
          // Get the response message and deal with it
          string responseXML = RetrieveHMRCResponse(FPendingDocument);
          Result = HandleHMRCResponse(responseXML);

          if (Result != 0)
            {
            Log.Add("Error handling HMRC response : Code " + Result.ToString());
            }
          }

        FPendingDocument = SelectNextDocument();
        if (FPendingDocument != null)
          {
          PrepareHMRCRequest(FPendingDocument);
          }
        }
      finally
        {
        StartPolling();
        }

      return Result;
      }

    /// <summary>
    /// Sets the correct submission URL and polling interval for the 
    /// supplied submission. Once this has been called, the PollingService
    /// will wait for the specified interval, and then call the HMRC
    /// service.
    /// </summary>
    /// <param name="record"></param>
    /// <returns></returns>
    private void PrepareHMRCRequest(DocumentRecord record)
      {
      pollingTimer.Interval = record.theDocument.pollingInterval * SECONDS_TO_TIMER_INTERVAL_MULTIPLIER;

      //      Log.Add(string.Format("Preparing request for HMRC service, polling interval of {0}", pollingTimer.Interval));

      switch (record.theDocument.documentType)
        {
        case "STD":
          FPendingDocument.docClass = HMRCFilingServiceProcessor.MESSAGE_CLASS_VAT_RETURN;
          destURL = HMRCFilingServiceProcessor.HMRC_LIVE_URL;
          break;

        case "TIL":
          FPendingDocument.docClass = HMRCFilingServiceProcessor.MESSAGE_CLASS_VAT_RETURN_TIL;
          destURL = HMRCFilingServiceProcessor.HMRC_LIVE_URL;
          break;

        case "DEV":
          FPendingDocument.docClass = HMRCFilingServiceProcessor.MESSAGE_CLASS_VAT_RETURN;
          destURL = HMRCFilingServiceProcessor.HMRC_DEV_URL;
          break;
        }
      return;
      }

    /// <summary>
    /// Calls the HMRC Gateway web-service to retrieve the current status of the
    /// VAT Submission supplied in the Document Record, and returns an XML string
    /// of the results.
    /// </summary>
    /// <param name="record"></param>
    /// <returns></returns>
    private string RetrieveHMRCResponse(DocumentRecord record)
      {
      VAT100_Poll pollMessage = new VAT100_Poll();
      pollMessage.Header.MessageDetails.Class = record.docClass;
      pollMessage.Header.MessageDetails.CorrelationID = record.theDocument.correlationID;
      string pollMsg;

      // Serialize the message to a string
      XmlSerializer xmlSerializer = new XmlSerializer(pollMessage.GetType());
      //SS:04/06/2018:2018-R1:ABSEXCH-20538:VAT 100 Submissions failing due to HMRC gateway changes
      using (Utf8StringWriter textWriter = new Utf8StringWriter())
        {
        xmlSerializer.Serialize(textWriter, pollMessage);
        pollMsg = textWriter.ToString();
        }

      // Submit the resulting XML to HMRC
      // Create a request
      var request = (HttpWebRequest)WebRequest.Create(FPendingDocument.theDocument.PollingURL);
      var data = Encoding.ASCII.GetBytes(pollMsg);

      request.Method = "POST";
      request.ContentType = "application/x-www-form-urlencoded";
      request.ContentLength = data.Length;

      // Write the data to the request parameters
      using (var stream = request.GetRequestStream())
        {
        stream.Write(data, 0, data.Length);
        }

      // Send the request and get the response.
      var response = (HttpWebResponse)request.GetResponse();

      // Get the response in a stream.
      var responseData = new StreamReader(response.GetResponseStream()).ReadToEnd();

      // Convert the stream to a string
      string responseXML = responseData.ToString();

      return responseXML;
      }

    /// <summary>
    /// Handles the response returned from the HMRC Gateway for the VAT Submission
    /// that is currently being processed. Returns false if the response is either
    /// that the VAT Return was in error or if it was accepted successfully, and
    /// therefore that polling should be stopped. Otherwise it returns true, and
    /// polling should continue.
    /// </summary>
    /// <param name="responseXML"></param>
    /// <returns></returns>
    private int HandleHMRCResponse(string responseXML)
      {
      string filename;
      int Result = 0;

      // Deserialise the response.  At this point we don't know if its a business response or an error response.
      VAT100_BusinessResponseMessage responseMsg = null;
      VAT100_BusinessErrorResponse errorMsg = null;

      try
        {
        XmlSerializer responseSerialiser = new XmlSerializer(typeof(VAT100_BusinessResponseMessage));
        using (StringReader reader = new StringReader(responseXML))
          {
          responseMsg = (VAT100_BusinessResponseMessage)(responseSerialiser.Deserialize(reader));
          }

        XmlSerializer errorSerialiser = new XmlSerializer(typeof(VAT100_BusinessErrorResponse));
        using (StringReader reader = new StringReader(responseXML))
          {
          errorMsg = (VAT100_BusinessErrorResponse)(errorSerialiser.Deserialize(reader));
          }
        }
      catch (Exception ex)
        {
        LogText("Error handling HMRC response : " + ex.Message);
        }

      //...........................................................................................
      // Determine the response type.
      // For a pending submission, this will be "acknowledgement"
      // For a successful submission, this will be "response"
      // For a submission failure, this will be "error"
      string responseType = responseMsg.Header.MessageDetails.Qualifier; // response, error, acknowledgement
      string function = responseMsg.Header.MessageDetails.Function;

      switch (responseType.ToLower())
        {
        case "acknowledgement":
          // Nothing to do.  We'll continue polling until we get a business response or an error.
          Log.Add("Acknowledgement received");
          Result = 0;
          break;

        case "response":
          // Business Response. We can stop polling, save the data and then delete the request (unless it was a delete).
          Log.Add("Response received");

          // CJS 2015-09-24 - ABSEXCH-16922 - HMRC Filing VAT Submissions xml folder
          // Save the XML
          filename = string.Format("response{0}.xml", responseMsg.Body.SuccessResponse.ResponseData.VATDeclarationResponse.Header.VATPeriod.PeriodId);
          XMLWrite.ToReceivedFolder(FDatabase.tToolkit.Configuration.EnterpriseDirectory, filename, responseXML);

          Result = ProcessBusinessResponse(responseMsg);
          if (function.ToLower() != "delete")
            {
            Delete(FPendingDocument.theDocument.correlationID);
            }
          break;

        case "error":
          Log.Add("Error response received");

          // CJS 2015-09-24 - ABSEXCH-16922 - HMRC Filing VAT Submissions xml folder
          // Save the XML
          DateTime timenow = DateTime.Now;
          filename = string.Format("error{0:yyyyMMdd_hhmm}.xml", timenow);
          XMLWrite.ToReceivedFolder(FDatabase.tToolkit.Configuration.EnterpriseDirectory, filename, responseXML);

          // Error Response. We can stop polling, save the data and then delete the request (unless it was a delete).
          Result = ProcessErrorResponse(errorMsg);
          if (function.ToLower() != "delete")
            {
            Delete(FPendingDocument.theDocument.correlationID);
            }
          break;

        default:
          // Unrecognised response qualifier
          throw new Exception("Unexpected response received from HMRC");
        }
      return Result;
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Fires when the Polling Timer elapses.
    /// </summary>
    /// <param name="source"></param>
    /// <param name="e"></param>
    private void OnTimerElapsedEvent(Object source, ElapsedEventArgs e)
      {
      ProcessPendingDocument();
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Handle a non-error response from HMRC
    /// </summary>
    /// <param name="aResponse"></param>
    private int ProcessBusinessResponse(VAT100_BusinessResponseMessage aResponse)
      {
      // The response was favourable
      int Result = 0;

      // Extract all the narrative from the response. Start with an error message that should get overwritten
      string narrative = string.Empty;

      // PKR. 17/09/2015.
      // Now check each level exists before attempting to extract the data as it was
      // raising an exception.  Also wrap in a try..finally for good measure.
      try
        {
        try
          {
          if (aResponse.Body.SuccessResponse != null)
            {
            // The SuccessResponse Message
            if (aResponse.Body.SuccessResponse.Message != null)
              {
              narrative += aResponse.Body.SuccessResponse.Message + "\r\n\r\n"; // Typically "Thank you for your submission..."
              }

            // The IRMarkReceipt message
            if (aResponse.Body.SuccessResponse.IRmarkReceipt != null)
              {
              if (aResponse.Body.SuccessResponse.IRmarkReceipt.IRmarkReceiptMessage != null)
                {
                narrative += aResponse.Body.SuccessResponse.IRmarkReceipt.IRmarkReceiptMessage + "\r\n\r\n"; // "HMRC has received the HMRC-VAT-DEC document..."
                }
              }

            // Acceptance time
            if (aResponse.Body.SuccessResponse.AcceptedTime != null)
              {
              narrative += string.Format("Submission accepted at {0}\r\n\r\n", aResponse.Body.SuccessResponse.AcceptedTime);
              }

            // 
            if (aResponse.Body.SuccessResponse.ResponseData != null)
              {
              if (aResponse.Body.SuccessResponse.ResponseData.VATDeclarationResponse != null)
                {
                if (aResponse.Body.SuccessResponse.ResponseData.VATDeclarationResponse.Header != null)
                  {
                  if (aResponse.Body.SuccessResponse.ResponseData.VATDeclarationResponse.Header.VATPeriod != null)
                    {
                    narrative += string.Format("VAT Period : {0}\r\nStart Date : {1}\r\nEnd Date   : {2}\r\n\r\n",
                      aResponse.Body.SuccessResponse.ResponseData.VATDeclarationResponse.Header.VATPeriod.PeriodId,
                      aResponse.Body.SuccessResponse.ResponseData.VATDeclarationResponse.Header.VATPeriod.PeriodStartDate,
                      aResponse.Body.SuccessResponse.ResponseData.VATDeclarationResponse.Header.VATPeriod.PeriodEndDate);
                    }
                  }

                if (aResponse.Body.SuccessResponse.ResponseData.VATDeclarationResponse.Body != null)
                  {
                  if (aResponse.Body.SuccessResponse.ResponseData.VATDeclarationResponse.Body.PaymentNotification != null)
                    {
                    if (aResponse.Body.SuccessResponse.ResponseData.VATDeclarationResponse.Body.PaymentNotification.Narrative != null)
                      {
                      narrative += aResponse.Body.SuccessResponse.ResponseData.VATDeclarationResponse.Body.PaymentNotification.Narrative + "\r\n\r\n";
                      // If there is VAT to pay, then include the due date
                      double netVat = aResponse.Body.SuccessResponse.ResponseData.VATDeclarationResponse.Body.PaymentNotification.NetVAT;
                      if (netVat > 0.0)
                        {
                        narrative += "Payment due date : " + aResponse.Body.SuccessResponse.ResponseData.VATDeclarationResponse.Body.PaymentDueDate + "\r\n";
                        narrative += string.Format("Amount due       : {0}", netVat) + "\r\n\r\n";
                        }
                      }
                    }

                  if (aResponse.Body.SuccessResponse.ResponseData.VATDeclarationResponse.Body.InformationNotification != null)
                    {
                    if (aResponse.Body.SuccessResponse.ResponseData.VATDeclarationResponse.Body.InformationNotification.Narrative != null)
                      {
                      narrative += aResponse.Body.SuccessResponse.ResponseData.VATDeclarationResponse.Body.InformationNotification.Narrative + "\r\n\r\n";
                      }
                    }
                  }
                }
              }
            }
          }
        catch (Exception ex)
          {
          Log.Add("Error processing response from HMRC. " + ex.Message);
          }
        } // end try
      finally
        {
        if (narrative == string.Empty)
          {
          narrative = "Error decoding response message from HMRC";
          }

        // Update the pending document status
        FPendingDocument.theDocument.status = Convert.ToInt16(SubmissionStatus.ssAccepted);

        // Add the narrative
        FPendingDocument.theDocument.hmrcNarrative = narrative;

        // Save the record
        Log.Add("Updating record in database for " + FPendingDocument.theDocument.correlationID);
        Result = VAT100Database.Instance.UpdateVAT100Entry(FPendingDocument.theDocument, FPendingDocument.companyCode);
        }

      return Result;
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Handle an error response from HMRC
    /// </summary>
    /// <param name="aResponse"></param>
    private int ProcessErrorResponse(VAT100_BusinessErrorResponse aResponse)
      {
      // The response was not good news
      string errorNarrative = string.Empty;

      int Result = 0;

      VAT100BusinessResponseDetails details = aResponse.GovTalkDetails;
      if (details.GovTalkErrors.Count > 0)
        {
        for (int index = 0; index < details.GovTalkErrors.Count; index++)
          {
          GovTalkError error = details.GovTalkErrors[index];
          errorNarrative += error.Error.Text + "\n\r\n\r";
          }
        }

      // GovTalkErrors done.  Now look for messages in the <Body>
      if (aResponse.Body.ErrorResponse != null)
        {
        if (aResponse.Body.ErrorResponse.ErrorList.Length > 0)
          {
          foreach (VAT100_ErrorResponseError error in aResponse.Body.ErrorResponse.ErrorList)
            {
            errorNarrative += error.Text + "\n\r\n\r";
            errorNarrative += error.Location + "\n\r";
            }
          }
        }

      // Update its status
      FPendingDocument.theDocument.status = Convert.ToInt16(SubmissionStatus.ssError);

      // Add the narrative
      FPendingDocument.theDocument.hmrcNarrative = errorNarrative;

      // Save the record
      Result = VAT100Database.Instance.UpdateVAT100Entry(FPendingDocument.theDocument, FPendingDocument.companyCode);

      return Result;
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Sends a request to delete the document from the HMRC front end.
    /// </summary>
    /// <param name="aCorrelationID"></param>
    private void Delete(string aCorrelationID)
      {
      // Compose and send a Delete message
      string deleteMsg;
      VAT100_DeleteRequest deleteRequest = new VAT100_DeleteRequest();

      // The constructor fills in the fixed, mandatory fields.
      // All we need to do is fill in the CorrelationID and Class.
      deleteRequest.Header.MessageDetails.CorrelationID = FPendingDocument.theDocument.correlationID;
      deleteRequest.Header.MessageDetails.Class = FPendingDocument.docClass;

      // Serialise the request to XML
      using (StringWriter textWriter = new StringWriter())
        {
        XmlSerializer xmlSerializer = new XmlSerializer(deleteRequest.GetType());
        xmlSerializer.Serialize(textWriter, deleteRequest);
        deleteMsg = textWriter.ToString();
        }

      // Submit the resulting XML string to HMRC
      // Create a web request
      var request = (HttpWebRequest)WebRequest.Create(FPendingDocument.theDocument.PollingURL);
      var data = Encoding.ASCII.GetBytes(deleteMsg);

      // Send the request
      request.Method = "POST";
      request.ContentType = "application/x-www-form-urlencoded";
      request.ContentLength = data.Length;

      // Write the data to the request parameters
      using (var stream = request.GetRequestStream())
        {
        stream.Write(data, 0, data.Length);
        }

      // Send the request and get the response.
      var response = (HttpWebResponse)request.GetResponse();

      // Get the response in a stream.
      var responseData = new StreamReader(response.GetResponseStream()).ReadToEnd();

      // Convert the stream to a string
      string responseXML = responseData.ToString();

      // Deserialise the response
      VAT100_DeleteResponse responseMsg;

      XmlSerializer serialiser = new XmlSerializer(typeof(VAT100_DeleteResponse));
      using (StringReader reader = new StringReader(responseXML))
        {
        responseMsg = (VAT100_DeleteResponse)(serialiser.Deserialize(reader));
        }

      // There isn't anything to be done with the response.  Also, if we don't delete the document,
      //  it will automatically expire some time in the future, so it doesn't matter if the
      //  response is in error or not.
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Scans the VAT100 tables in all companies to find the next VAT
    /// submission that is waiting for a response from HMRC, and returns
    /// a DocumentRecord containing the details.
    /// </summary>
    /// <returns></returns>
    private DocumentRecord SelectNextDocument()
      {
      Enterprise04.ICompanyDetail CompanyDetail;

      DocumentRecord document = null;

      // Cycle through all the companies
      int CompanyCount = FDatabase.tToolkit.Company.cmCount;
      for (int i = 1; i <= CompanyCount; i++)
        {
        // Point the Toolkit at the company path (getPendingVAT100Entry will
        // open and close the Toolkit using this path)
        CompanyDetail = FDatabase.tToolkit.Company.get_cmCompany(i);

        // Find any pending VAT Submission for this company and add it to the list
        VAT100Record Entry = FDatabase.GetPendingVAT100Entry(CompanyDetail.coCode);
        if (Entry != null)
          {
          document = new DocumentRecord();
          document.theDocument = Entry;
          document.companyCode = CompanyDetail.coCode;
          document.companyPath = CompanyDetail.coPath;
          document.status = ServiceStatus.ssPolling;
          break;
          }
        }

      if (document == null)
        {
        // No more pending documents, so revert back to the 
        // slow polling interval.
        pollingTimer.Interval = DEFAULT_POLLING_INTERVAL;
        }

      return document;
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Starts the timer to control polling for a response
    /// </summary>
    public void StartPolling()
      {
      pollingTimer.Enabled = true;
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Stops the polling timer.
    /// </summary>
    public void StopPolling()
      {
      pollingTimer.Enabled = false;
      }

    //---------------------------------------------------------------------------------------------
    public static void LogText(string message)
      {
      Log.Add(message);
      }
    }
  }