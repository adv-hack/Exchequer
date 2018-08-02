using System;
using System.IO;
using System.Net;
using System.Text;
using System.Windows.Forms;
using System.Xml.Serialization;
using HMRCFilingService;
using HMRCFilingService.GovTalkMessages;

namespace HMRCStatusChecker
  {
  public partial class mainform : Form
    {
    public mainform()
      {
      InitializeComponent();
      }

    private void comboUserID_SelectedIndexChanged(object sender, EventArgs e)
      {
      int index = comboUserID.SelectedIndex;
      comboVATRegNo.SelectedIndex = index;
      }

    private void btnPoll_Click(object sender, EventArgs e)
      {
      DocumentRecord record = new DocumentRecord();
      btnPoll.Enabled = false;
      btnDelete.Enabled = false;
      pollTimer.Enabled = true;

      VAT100_Poll pollMessage = new VAT100_Poll();
      pollMessage.Header.MessageDetails.Class = "HMRC-VAT-DEC";
      pollMessage.Header.MessageDetails.CorrelationID = editCorrelationID.Text;

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
      var request = (HttpWebRequest)WebRequest.Create(comboTargetURL.Text /* + @"\poll" */);
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
      WebResponse response = null;
      try
        {
        response = (HttpWebResponse)request.GetResponse();
        }
      catch (Exception ex)
        {
        textNarrative.AppendText("Error submitting Poll request\r\n" + ex.Message);
        return;
        }

      // Get the response in a stream.
      var responseData = new StreamReader(response.GetResponseStream()).ReadToEnd();

      // Convert the stream to a string
      string responseXML = responseData.ToString();

      HandleHMRCResponse(responseXML);
      }

    private int HandleHMRCResponse(string responseXML)
      {
      int Result = 0;

      // Deserialise the response
      VAT100_BusinessResponseMessage responseMsg;
      VAT100_BusinessErrorResponse errorMsg;

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

      //...........................................................................................
      // Determine the response type.
      // For a pending submission, this will be "acknowledgement"
      // For a successful submission, this will be "response"
      // For a submission failure, this will be "error"
      string responseType = responseMsg.Header.MessageDetails.Qualifier;
      string function = responseMsg.Header.MessageDetails.Function;

      switch (responseType.ToLower())
        {
        case "acknowledgement":
          textNarrative.AppendText("Acknowledgement received\r\n");
          Result = 0;
          break;

        case "response":
          // Business Response.
          textNarrative.AppendText("Response received\r\n");
          Result = ProcessBusinessResponse(responseMsg);
          break;

        case "error":
          // Error Response.
          textNarrative.AppendText("Error response received\r\n");
          Result = ProcessErrorResponse(errorMsg);
          break;

        default:
          // Unrecognised response qualifier
          throw new Exception("Unexpected response received from HMRC");
        }
      return Result;
      }

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

      // Add the narrative
      textNarrative.AppendText(errorNarrative + "\r\n\r\n");

      return Result;
      }

    private int ProcessBusinessResponse(VAT100_BusinessResponseMessage aResponse)
      {
      // The response was favourable
      int Result = 0;

      // Extract all the narrative from the response
      string narrative = aResponse.Body.SuccessResponse.Message + "\r\n\r\n"; // Typically "Thank you for your submission"
      narrative += aResponse.Body.SuccessResponse.IRmarkReceipt.IRmarkReceiptMessage + "\r\n\r\n"; // "HMRC has received the HMRC-VAT-DEC document..."
      narrative += aResponse.Body.SuccessResponse.ResponseData.VATDeclarationResponse.Body.PaymentNotification.Narrative + "\r\n\r\n";

      // If there is VAT to pay, then include the due date
      double netVat = aResponse.Body.SuccessResponse.ResponseData.VATDeclarationResponse.Body.PaymentNotification.NetVAT;
      if (netVat > 0.0)
        {
        narrative += "Payment due date : " + aResponse.Body.SuccessResponse.ResponseData.VATDeclarationResponse.Body.PaymentDueDate + "\r\n\r\n";
        }

      // Add the narrative
      textNarrative.AppendText(narrative + "\r\n\r\n");

      return Result;
      }

    private void btnDelete_Click(object sender, EventArgs e)
      {
      btnPoll.Enabled = false;
      btnDelete.Enabled = false;
      pollTimer.Enabled = true;
      Delete(editCorrelationID.Text);
      }

    private void Delete(string aCorrelationID)
      {
      // Compose and send a Delete message
      string deleteMsg;
      VAT100_DeleteRequest deleteRequest = new VAT100_DeleteRequest();

      // The constructor fills in the fixed, mandatory fields.
      // All we need to do is fill in the CorrelationID and Class.
      deleteRequest.Header.MessageDetails.CorrelationID = editCorrelationID.Text;
      deleteRequest.Header.MessageDetails.Class = "HMRC-VAT-DEC";

      // Serialise the request to XML
      using (StringWriter textWriter = new StringWriter())
        {
        XmlSerializer xmlSerializer = new XmlSerializer(deleteRequest.GetType());
        xmlSerializer.Serialize(textWriter, deleteRequest);
        deleteMsg = textWriter.ToString();
        }

      // Submit the resulting XML string to HMRC
      // Create a web request
      var request = (HttpWebRequest)WebRequest.Create(comboTargetURL.Text);
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

      HandleHMRCResponse(responseXML);
      }


    private void btnHelp_Click(object sender, EventArgs e)
      {
      Help helpDlg = new Help();
      helpDlg.ShowDialog();
      helpDlg = null;
      }

    private void pollTimer_Tick(object sender, EventArgs e)
      {
      btnPoll.Enabled = true;
      btnDelete.Enabled = true;
      pollTimer.Enabled = false;
      }
    }
  }