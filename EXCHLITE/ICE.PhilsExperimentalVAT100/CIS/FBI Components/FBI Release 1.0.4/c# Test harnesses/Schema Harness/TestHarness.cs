using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using IRIS.Systems.InternetFiling;
using System.Xml;
using System.IO;
using IRIS.Tax.xmlFormer;

using System.Reflection;
using System.Runtime.InteropServices;

namespace Schema_Harness
{
    public partial class ct600Harness : Form
    {

        internal class CCursor : IDisposable
        {
            private Cursor saved = null;

            public CCursor(Cursor newCursor)
            {
                saved = Cursor.Current;

                Cursor.Current = newCursor;
            }

            public void Dispose()
            {
                Cursor.Current = saved;
            }
        }

        internal class CWaitCursor : CCursor
        {
            public CWaitCursor() : base(Cursors.WaitCursor) { }
        }

        // constructor

        public ct600Harness()
        {
            InitializeComponent();

            posting = new Posting();
            deletePosting = new Posting();
            
            callBacks = new harnessCallBackContainer();
            callBacks.onSubmitSuccess += new CallbackEventHandler(callBacks_onSubmitSuccess);
            callBacks.onSubmitError += new CallbackEventHandler(callBacks_onSubmitError);
            callBacks.onSubmitAck += new CallbackEventHandler(callBacks_onSubmitAck);

            deleteCallBacks = new harnessCallBackContainer();
            deleteCallBacks.onDeleteSuccess += new CallbackEventHandler(callBacks_onDeleteSuccess);
            deleteCallBacks.onDeleteError += new CallbackEventHandler(callBacks_onDeleteError);
            deleteCallBacks.onDeleteAck += new CallbackEventHandler(callBacks_onDeleteAck);

            transmissionObject = new CxmlTransmission();


            rawXMLInput.Text = "w:\\development\\xml\\CT485_37710.xml";
            HMRCoutputXML.Text = "w:\\development\\xml\\final_hmrc.xml";
            xslFilename.Text = "w:\\development\\ct600.xsl";

            
            Type clsType = typeof(ct600Harness);
            // Get the assembly object.
            Assembly assy = clsType.Assembly;
            String l_Version = assy.GetName().Version.ToString();

            // Normally we'd start the polling to the submission address until it changed.
            // however until the InternetFilling supports the change, we can't
            m_PollingURL = "https://secure.dev.gateway.gov.uk/poll";
            //m_PollingURL = "https://secure.dev.gateway.gov.uk/submission";


        }

        void callBacks_onSubmitSuccess(string Guid, string message)
        {
            XmlDocument myXmlDocument = new XmlDocument();
            myXmlDocument.LoadXml(message);
            myXmlDocument.Save("w:\\development\\xml\\submissionSuccess.xml");
            posting.EndPolling(Guid);
        }

        void callBacks_onSubmitError(string Guid, string message)
        {
            XmlDocument myXmlDocument = new XmlDocument();
            myXmlDocument.LoadXml(message);
            myXmlDocument.Save("w:\\development\\xml\\submissionError.xml");
            posting.EndPolling(Guid);
        }

        void callBacks_onSubmitAck(string Guid, string message)
        {
            // temporary change to test redirection
            //posting.RedirectPolling(Guid, "https://secure.dev.gateway.gov.uk/poll");
            //return;
            XmlDocument myXmlDocument = new XmlDocument();
            myXmlDocument.LoadXml(message);
            XmlNodeList myXmlNodeList = myXmlDocument.GetElementsByTagName("ResponseEndPoint");
            String l_responseEndPoint = myXmlNodeList.Item(0).InnerText;

            if (l_responseEndPoint != m_PollingURL)
            {
                m_PollingURL = l_responseEndPoint;
                // Ideally it'd be nice to be able to check where the original polling
                // was going to so we don't change it needlessly,
                // but this will do for the moment.
                //posting.RedirectPolling(Guid, m_PollingURL,callBacks);
                myXmlDocument.Save("w:\\development\\xml\\submissionAckchangeEP.xml");
            }
            else
            {
                myXmlDocument.Save("w:\\development\\xml\\submissionAck.xml");
            }
        }

        void callBacks_onDeleteSuccess(string Guid, string message)
        {
            XmlDocument myXmlDocument = new XmlDocument();
            myXmlDocument.LoadXml(message);
            myXmlDocument.Save("w:\\development\\xml\\deleteSuccess.xml");
            posting.EndPolling(Guid);
        }

        void callBacks_onDeleteError(string Guid, string message)
        {
            XmlDocument myXmlDocument = new XmlDocument();
            myXmlDocument.LoadXml(message);
            myXmlDocument.Save("w:\\development\\xml\\deleteError.xml");
            posting.EndPolling(Guid);
        }

        void callBacks_onDeleteAck(string Guid, string message)
        {
            // temporary change to test redirection
            //posting.RedirectPolling(Guid, "https://secure.dev.gateway.gov.uk/poll");
            //return;
            XmlDocument myXmlDocument = new XmlDocument();
            myXmlDocument.LoadXml(message);
            XmlNodeList myXmlNodeList = myXmlDocument.GetElementsByTagName("ResponseEndPoint");
            String l_responseEndPoint = myXmlNodeList.Item(0).InnerText;
            if (l_responseEndPoint != m_PollingURL)
            {
                m_PollingURL = l_responseEndPoint;
                // Ideally it'd be nice to be able to check where the original polling
                // was going to so we don't change it needlessly,
                // but this will do for the moment.
                //posting.RedirectPolling(Guid, l_responseEndPoint,callBacks);
                myXmlDocument.Save("w:\\development\\xml\\deleteAckchangeEP.xml");
            }
            else
            {
                myXmlDocument.Save("w:\\development\\xml\\deleteAck.xml");
            }
        }

        private String irMarkTestDirect()
        {
            StreamReader re = File.OpenText("w:\\development\\xml\\marked_output.xml");//w:\\development\\example_ct2004d.xml");
            string streamString = re.ReadToEnd();
            re.Close();

            Posting posting = new Posting();
            String tempString = posting.AddIRMark(ref streamString, 3);

            XmlDocument markedXML = new XmlDocument();
            markedXML.LoadXml(streamString);
            markedXML.Save("w:\\development\\xml\\marked_output.xml");

            return tempString;
        }
        
        private String submitReturnDirect()
        {
            //Posting posting = new Posting();
            String l_Response = "";

            posting.SetConfiguration(m_SubmissionURL);
            String DocumentType = "IR-CT-CT600";
            bool UsesTestGateway = true;
            StreamReader re = File.OpenText("w:\\development\\xml\\marked_output.xml");
            String fileName = re.ReadToEnd();
            re.Close();

            try
            {
                l_Response = posting.Submit(DocumentType,
                                            UsesTestGateway,
                                            fileName);
            }
            catch (System.Exception)
            {
            }

            // l_Response contains the XML back from the gateway - not sure what we're going to do with that
            // (apart from the obivious to check for a success)
            // we need to note the ResponseEndPoint in the response, as this is the URL the poller needs to use.
            // this looks like it will be the submission gateway used, but it has the option to change.
            // The poll interval should be paid attention to in the response too. I can't see a way for us to tell
            // the poller about this yet.

            return l_Response;
        }

        private String buildPollingMessage(String correlationID)
        {
            XmlDocument myXmlDocument = new XmlDocument();
            myXmlDocument.Load("w:\\development\\xml\\sample_polling_message.xml");


            XmlNodeList myXmlNodeList = myXmlDocument.GetElementsByTagName("CorrelationID");
            myXmlNodeList.Item(0).InnerText = correlationID;

            myXmlDocument.Save("w:\\development\\xml\\polling_message.xml");

            StreamReader re = File.OpenText("w:\\development\\xml\\polling_message.xml");
            String pollingXML = re.ReadToEnd();
            re.Close();
            return pollingXML;
        }

        // Form activated methods

        private bool transformBasicXML(String inputFilename, String outputFilename, String xslLocation)
        {
            System.Xml.Xsl.XslCompiledTransform xslt = new System.Xml.Xsl.XslCompiledTransform();
            xslt.Load(xslLocation);

            //Create a new XPathDocument and load the XML data to be transformed.
            System.Xml.XPath.XPathDocument mydata = new System.Xml.XPath.XPathDocument(inputFilename);

            //Create an XmlTextWriter which outputs to the console.
            System.Xml.XmlWriter writer = new System.Xml.XmlTextWriter(outputFilename, System.Text.Encoding.UTF8);

            //Transform the data and send the output to the file.
            xslt.Transform(mydata, null, writer);

            writer.Close();

            return true;
        }

        private String irMarkTestPassedFile(String inputFileName, String outputFileName)
        {
            StreamReader re = File.OpenText(inputFileName);//w:\\development\\example_ct2004d.xml");
            string streamString = re.ReadToEnd();
            re.Close();

            //Posting posting = new Posting();
            String tempString = posting.AddIRMark(ref streamString, 3);

            XmlDocument markedXML = new XmlDocument();
            markedXML.LoadXml(streamString);
            markedXML.Save(outputFileName);

            return tempString;
        }

        private String submitReturn(String passedFilename)
        {
            posting.SetConfiguration(m_SubmissionURL);

            String DocumentType = "IR-CT-CT600";
            bool UsesTestGateway = true;
            StreamReader re = File.OpenText(passedFilename);
            string fileName = re.ReadToEnd();
            re.Close();

            //Posting posting = new Posting();
            String l_Response = "";

            try
            {
                l_Response = posting.Submit(DocumentType,
                                            UsesTestGateway,
                                            fileName);
            }
            catch (System.Exception)
            {
            }

            return l_Response;
        }
        
        private String getCorrelationIDfromXML(String xmlString)
        {

            //XmlDataDocument myXmlDataDocument = new XmlDataDocument();
            XmlDocument myXmlDocument = new XmlDocument();
            myXmlDocument.LoadXml(xmlString);

            XmlNodeList myXmlNodeList = myXmlDocument.GetElementsByTagName("CorrelationID");
            String tempString = myXmlNodeList.Item(0).InnerText;

            myXmlDocument.Save(@"w:\development\xml\submissionResponse.xml");
            return tempString;
        }

        private String pollGateway(String correlationID, String classValue)
        {
            String l_Guid = "";

            callBacks.Response(l_Guid);

            bool UsesTestGateway = true;

            try
            {


                l_Guid = posting.BeginPolling(callBacks,
                                                  correlationID,
                                                  classValue,
                                                  UsesTestGateway,
                                                    //m_SubmissionURL);
                                                  m_PollingURL);
                                            
                
            }
            catch (System.Exception ex)
            {
               Console.WriteLine(ex.ToString());
            
            }
            callBacks.Guid = l_Guid;
            return callBacks.Guid;

        }

        private String pollDeleteGateway(String correlationID, String classValue)
        {
            String l_Guid = "";

            callBacks.Response(l_Guid);

            bool UsesTestGateway = true;

            try
            {
                l_Guid = posting.BeginPolling(deleteCallBacks,
                                                  correlationID,
                                                  classValue,
                                                  UsesTestGateway,
                                                  //  m_SubmissionURL);
                                                  m_PollingURL);


            }
            catch (System.Exception)
            {
            }
            callBacks.Guid = l_Guid;
            return callBacks.Guid;

        }
        

        // Button events

        private void generateIRMark_Click(object sender, EventArgs e)
        {
            if (harnessRadio.Checked || transmissionRadio.Checked)
            {
                using (new CWaitCursor())
                {
                    irMarkTextBox.Text = irMarkTestPassedFile(HMRCXMLinput.Text, IRmarkedOutput.Text);
                    submitInput.Text = IRmarkedOutput.Text;
                }
            }
            else
            {
                Cct600xmlFormer myCT600Former = new Cct600xmlFormer();
                String irMark = "";
                myCT600Former.getIRMark(HMRCXMLinput.Text, ref irMark);
                irMarkTextBox.Text = irMark;
            }
        }

        private void transformButton_Click(object sender, EventArgs e)
        {
            if (harnessRadio.Checked || transmissionRadio.Checked)
            {
                using (new CWaitCursor())
                {
                    transformBasicXML(rawXMLInput.Text, HMRCoutputXML.Text, xslFilename.Text);
                    HMRCXMLinput.Text = HMRCoutputXML.Text;
                    IRmarkedOutput.Text = "w:\\development\\xml\\marked_final_hmrc.xml";
                }
            }
            else
            {
                Cct600xmlFormer myCT600Former = new Cct600xmlFormer();
                myCT600Former.transform(rawXMLInput.Text);
            }
        }

        private void submitButton_Click(object sender, EventArgs e)
        {
            if (harnessRadio.Checked)
            {
                using (new CWaitCursor())
                {
                    String responseXML = submitReturn(submitInput.Text);
                    correlationIDTextBox.Text = getCorrelationIDfromXML(responseXML);
                }
            }
            else if (transmissionRadio.Checked)
            {
                using (new CWaitCursor())
                {
                    bool l_IsTestMessage = true;
                    bool l_UsesTestGateway = true;
                    String responseXML = transmissionObject.submitReturn(submitInput.Text, l_IsTestMessage, l_UsesTestGateway);
                    correlationIDTextBox.Text = transmissionObject.getCorrelationIDfromXML(responseXML, "w:\\development\\xml\\submissionResponse.xml");
                }
            }
            else
            {
                using (new CWaitCursor())
                {
                    Cct600xmlFormer myCT600Former = new Cct600xmlFormer();
                    String responseXML = myCT600Former.submitReturn(false, true, "w:\\development\\iris\\pam\\data\\Internet\\CT485_37710\\CT485_37710.xml",
                                                                                 "w:\\development\\iris\\pam\\data\\Internet\\CT485_37710\\response.xml");
                }
            }


        }

        private void sendPollingMessageButton_Click(object sender, EventArgs e)
        {
            bool l_UsesTestGateway = true;
            if (harnessRadio.Checked)
            {
                using (new CWaitCursor())
                {
                    guidBox.Text = pollGateway(correlationIDTextBox.Text, "IR-CT-CT600");
                }
            }
            else if (transmissionRadio.Checked)
            {
                using (new CWaitCursor())
                {
                    guidBox.Text = transmissionObject.pollGateway(correlationIDTextBox.Text, "IR-CT-CT600", l_UsesTestGateway);
                }
            }
            else
            {
            }
        }

        private void endPolling_Click(object sender, EventArgs e)
        {
            if (harnessRadio.Checked)
            {
                posting.EndPolling(guidBox.Text);
            }
            else if (transmissionRadio.Checked)
            {
            }
            else
            {
            }
        }

        private void deleteButton_Click(object sender, EventArgs e)
        {
            if (harnessRadio.Checked)
            {
                posting.Delete(correlationIDTextBox.Text, "IR-CT-CT600",
                    true, m_SubmissionURL);
                //posting.Delete(correlationIDTextBox.Text);
                deleteGUIDbox.Text = pollDeleteGateway(correlationIDTextBox.Text, "IR-CT-CT600");
            }
            else if (transmissionRadio.Checked)
            {
            }
            else
            {
            }
        }

        private void resetDataButton_Click(object sender, EventArgs e)
        {
            // not clearing these
            // rawXMLInput.Clear();
            // xslFilename.Clear();
            // HMRCoutputXML.Clear();

            HMRCXMLinput.Clear();
            IRmarkedOutput.Clear();
            irMarkTextBox.Clear();

            submitInput.Clear();
            correlationIDTextBox.Clear();
            guidBox.Clear();

            deleteGUIDbox.Clear();

            outputTextBox.Clear();

        }

        //  Data Members

        private Posting posting;
        private harnessCallBackContainer callBacks;
        private CxmlTransmission transmissionObject;

        private Posting deletePosting;
        private harnessCallBackContainer deleteCallBacks;

        private const String m_SubmissionURL = "https://secure.dev.gateway.gov.uk/submission";
        private String m_PollingURL = m_SubmissionURL;



    }
}