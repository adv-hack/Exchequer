using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Management;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Xml;
using System.Xml.Serialization;
using HMRCFilingService;
using HMRCFilingService.GovTalkMessages;
using IWshRuntimeLibrary;
using Enterprise04;
using EnterpriseBeta;
using DotNetLibrariesC.Toolkit;

namespace TestDecoder
  {
  public partial class Form1 : Form
    {
    public Form1()
      {
      InitializeComponent();
      }

    private void btnDeserialise_Click(object sender, EventArgs e)
      {
      VAT100_BusinessResponseMessage responseMsg = null;
      //      VAT100_BusinessErrorResponse errorMsg = null;

      try
        {
        XmlSerializer responseSerialiser = new XmlSerializer(typeof(VAT100_BusinessResponseMessage));
        using (StringReader reader = new StringReader(editXML.Text))
          {
          responseMsg = (VAT100_BusinessResponseMessage)(responseSerialiser.Deserialize(reader));
          }

        //        XmlSerializer errorSerialiser = new XmlSerializer(typeof(VAT100_BusinessErrorResponse));
        //        using (StringReader reader = new StringReader(editXML.Text))
        //          {
        //          errorMsg = (VAT100_BusinessErrorResponse)(errorSerialiser.Deserialize(reader));
        //          }
        }
      catch (Exception ex)
        {
        MessageBox.Show("Error handling HMRC response : " + ex.Message);
        }

      string narrative = string.Empty;
      if (responseMsg.Body.SuccessResponse != null)
        {
        // The SuccessResponse Message
        if (responseMsg.Body.SuccessResponse.Message != null)
          {
          narrative += responseMsg.Body.SuccessResponse.Message + "\r\n\r\n"; // Typically "Thank you for your submission..."
          }

        // The IRMarkReceipt message
        if (responseMsg.Body.SuccessResponse.IRmarkReceipt != null)
          {
          if (responseMsg.Body.SuccessResponse.IRmarkReceipt.IRmarkReceiptMessage != null)
            {
            narrative += responseMsg.Body.SuccessResponse.IRmarkReceipt.IRmarkReceiptMessage + "\r\n\r\n"; // "HMRC has received the HMRC-VAT-DEC document..."
            }
          }

        // Acceptance time
        if (responseMsg.Body.SuccessResponse.AcceptedTime != null)
          {
          narrative += string.Format("Submission accepted at {0}\r\n\r\n", responseMsg.Body.SuccessResponse.AcceptedTime);
          }

        //
        if (responseMsg.Body.SuccessResponse.ResponseData != null)
          {
          if (responseMsg.Body.SuccessResponse.ResponseData.VATDeclarationResponse != null)
            {
            if (responseMsg.Body.SuccessResponse.ResponseData.VATDeclarationResponse.Header != null)
              {
              if (responseMsg.Body.SuccessResponse.ResponseData.VATDeclarationResponse.Header.VATPeriod != null)
                {
                narrative += string.Format("VAT Period : {0}\r\nStart Date : {1}\r\nEnd Date   : {2}\r\n\r\n",
                  responseMsg.Body.SuccessResponse.ResponseData.VATDeclarationResponse.Header.VATPeriod.PeriodId,
                  responseMsg.Body.SuccessResponse.ResponseData.VATDeclarationResponse.Header.VATPeriod.PeriodStartDate,
                  responseMsg.Body.SuccessResponse.ResponseData.VATDeclarationResponse.Header.VATPeriod.PeriodEndDate);
                }
              }

            if (responseMsg.Body.SuccessResponse.ResponseData.VATDeclarationResponse.Body != null)
              {
              if (responseMsg.Body.SuccessResponse.ResponseData.VATDeclarationResponse.Body.PaymentNotification != null)
                {
                if (responseMsg.Body.SuccessResponse.ResponseData.VATDeclarationResponse.Body.PaymentNotification.Narrative != null)
                  {
                  narrative += responseMsg.Body.SuccessResponse.ResponseData.VATDeclarationResponse.Body.PaymentNotification.Narrative + "\r\n\r\n";
                  // If there is VAT to pay, then include the due date
                  double netVat = responseMsg.Body.SuccessResponse.ResponseData.VATDeclarationResponse.Body.PaymentNotification.NetVAT;
                  if (netVat > 0.0)
                    {
                    narrative += "Payment due date : " + responseMsg.Body.SuccessResponse.ResponseData.VATDeclarationResponse.Body.PaymentDueDate + "\r\n";
                    narrative += string.Format("Amount due       : {0}", netVat) + "\r\n\r\n";
                    }
                  }
                }

              if (responseMsg.Body.SuccessResponse.ResponseData.VATDeclarationResponse.Body.InformationNotification != null)
                {
                if (responseMsg.Body.SuccessResponse.ResponseData.VATDeclarationResponse.Body.InformationNotification.Narrative != null)
                  {
                  narrative += responseMsg.Body.SuccessResponse.ResponseData.VATDeclarationResponse.Body.InformationNotification.Narrative + "\r\n\r\n";
                  }
                }
              }
            }
          }
        }
      editNarrative.Text = narrative;
      }

    private void btnShares_Click(object sender, EventArgs e)
      {
      using (ManagementClass shares = new ManagementClass(@"\\p3738\", "Win32_Share", new ObjectGetOptions()))
        {
        foreach (ManagementObject share in shares.GetInstances())
          {
          editNarrative.AppendText("\r\n" + share["Name"]);
          editNarrative.AppendText("\r\n  " + share["Path"]);

          editNarrative.AppendText("\r\n");
          }
        }
      }

    private void button1_Click(object sender, EventArgs e)
      {
      string[] logicalDriveList = Environment.GetLogicalDrives();
      foreach (string drive in logicalDriveList)
        {
        editNarrative.AppendText("\r\n" + drive);
        }
      }

    private void btnMapping_Click(object sender, EventArgs e)
      {
//      string path = @"E:\ExchMapped\";
      string path = @"C:\EXCHEQR\ExchMapped\";
      string[] mappedDrives;
      if (System.IO.File.Exists(path + "MappedDrives.ini"))
        {
        mappedDrives = System.IO.File.ReadAllLines(path + "MappedDrives.ini");

        // Now set up mapped drives for this service to use
        foreach (string mappedDrive in mappedDrives)
          {
          string[] exploder = mappedDrive.Split('=');

          if (exploder.Count() > 1)
            {
            // Get the drive letter
            string drive = exploder[0];

            editNarrative.AppendText("Checking drive " + drive + "\r\n");

            // If the drive doen't exist, we need to map it.
            if (!Directory.Exists(drive))
              {
              // Get the UNC path
              string UNCpath = exploder[1];
              // Strip trailing backslashes.
              UNCpath = UNCpath.TrimEnd(new[] { '/', '\\' });

              editNarrative.AppendText("Mapping drive " + drive + " to " + UNCpath + "\r\n");
              // Create the mapping
              MapNetworkDrive(drive, UNCpath);
              }
            }
          }
        }
      }

    public void MapNetworkDrive(string driveLetter, string path)
      {
      IWshNetwork wshn = new WshNetwork();

      try
        {
        try
          {
          object missingArgument = Type.Missing;
          wshn.MapNetworkDrive(driveLetter, path, ref missingArgument, ref missingArgument, ref missingArgument);
          }
        catch (Exception ex)
          {
          // Ignore unc path
          editNarrative.AppendText(string.Format("\r\n\r\nHMRCFilingService: Error mapping drive {0} to {1}\r\n{2}", driveLetter, path, ex.Message));
          }
        }
      finally
        {
        wshn = null;
        }
      }
    }
  }