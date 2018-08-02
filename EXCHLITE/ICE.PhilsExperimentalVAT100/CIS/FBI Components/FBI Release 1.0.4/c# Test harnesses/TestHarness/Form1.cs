using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Text;
using System.Windows.Forms;
using System.Xml;
using IRIS.Systems.InternetFiling;

namespace TestHarness
{
   public partial class frmTestHarness : Form
   {
      private XmlDocument _return = new XmlDocument();
      string _xmlFile = "";
      Posting _broker = new Posting();
      
      public frmTestHarness()
      {
         InitializeComponent();

         // Load the XML... get the file...
         _xmlFile = (string.Format("{0}\\{1}", 
                        string.Format("{0}\\..\\..",Environment.CurrentDirectory),
                        "sampleReturnComplete.xml"));

         // ... load it....
         if (File.Exists(_xmlFile))
            _return.Load(_xmlFile);

         // ... display it
         this.txtXML.Text = _return.OuterXml;

      }

      private void cmdIRMark_Click(object sender, EventArgs e)
      {
         if (_return != null && _return.HasChildNodes) {
            // Submit the document for an IRMark
            string docXml = _return.InnerXml;
            string Amend;
            string irMark = _broker.AddIRMark(ref docXml, 3);

            if (irMark != "") {
               this.txtResults.Text = irMark;
               _return.InnerXml = docXml;

            }
            else
               this.txtResults.Text = "Nothing returned";

            this.txtXML.Text = _return.OuterXml;
            StreamWriter writer = new StreamWriter(string.Format("{0}\\{1}.xml",
                                                   Environment.GetFolderPath(Environment.SpecialFolder.Desktop),
                                                   (DateTime.Now.ToLongTimeString()).Replace(':', '_')));
            writer.Write(_return.OuterXml);
            writer.Close();

         }
      }

      private void cmdPost_Click(object sender, EventArgs e)
      {

         _broker.SetConfiguration(@"https://secure.dev.gateway.gov.uk/submission/ggsubmission.asp");
         string xmlDoc = _broker.Submit("IR-AB-AB123", true, _return.InnerXml);

         if (xmlDoc != null || xmlDoc != "") {
            this.txtXML.Text = xmlDoc;
            _return.InnerXml = xmlDoc;
            this.txtResults.Text = "Posting seemed to work";
         }
         else
            this.txtResults.Text = "Posting failed";
      }

      private string _guid = "";
      Callback callback;
      private void cmdPoll_Click(object sender, EventArgs e)
      {
         callback = new Callback();
         callback.ResponseReceived += new EventHandler(HandleCallbackResponse);
         _guid = _broker.BeginPolling(callback, "ABCDEFGHIJKLMNOPQRSTUVWXYZ123456", "IR-AB-AB123", true, @"https://secure.dev.gateway.gov.uk/submission");
         this.txtResults.Text = _guid;
      }

      private void cmdRedirect_Click(object sender, EventArgs e)
      {
         _broker.RedirectPolling(_guid, @"https://secure.dev.gateway.gov.uk/polling");

      }

      private void HandleCallbackResponse(object sender, EventArgs e)
      {
         this.txtXML.Text = sender.ToString();
      }

		private void cmdDelete_Click(object sender, EventArgs e)
		{
			_broker.Delete("ABCDEFGHIJKLMNOPQRSTUVWXYZ123456", "IR-AB-AB123", true, @"https://secure.dev.gateway.gov.uk/polling");
		}
   }

   internal class Callback : CallbackContainer
   {

      public event EventHandler ResponseReceived;
      
      public override void Response(string message)
      {
         if (ResponseReceived != null) {
            Control target = ResponseReceived.Target as Control;
            if (target != null && target.InvokeRequired) {
               target.Invoke(ResponseReceived, new object[] { message, EventArgs.Empty });
            }
            else {
               ResponseReceived((object)message, EventArgs.Empty);
            }


         }
      }

   }

}