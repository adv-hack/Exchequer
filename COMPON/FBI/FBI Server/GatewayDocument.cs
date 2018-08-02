using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Xml;

namespace IRIS.Systems.InternetFiling
  {
  [Serializable]
  public class GatewayDocument
    {
    private bool isTestMessage;
    private bool usesTestGateway;
    private bool requiresLogging;
    private bool requiresAuditing;

    private int applicationID;
    private int submissionID;

    private string documentID;
    private string documentType;
    private string correlationID;
    private string gatewayDoc;
    private string gatewayResponse;
    private string url;

    private DateTime lastPoll;
    private DateTime nextPoll;

    private DocumentStatus status;

    public GatewayDocument()
      {
      isTestMessage = false;
      usesTestGateway = false;
      requiresLogging = false;
      requiresAuditing = true;

      submissionID = 0;
      applicationID = 0;

      url = @"https://secure.dev.gateway.gov.uk/submission";
      // Should be 
      // url = @"https://secure.gateway.gov.uk/submission";

      status = DocumentStatus.NOSTATUS;

      nextPoll = new DateTime();
      nextPoll = nextPoll.AddYears(1752);

      lastPoll = new DateTime();
      lastPoll = nextPoll.AddYears(1752);
      }

    public GatewayDocument(DataRow currentRow)
      {
      submissionID = int.Parse(currentRow["SubmissionID"].ToString());
      documentID = currentRow["DocumentID"].ToString();
      applicationID = int.Parse(currentRow["ApplicationID"].ToString());
      gatewayDoc = currentRow["SubmittedDocument"].ToString();
      documentType = currentRow["DocumentType"].ToString();
      isTestMessage = (currentRow["IsTestMessage"].ToString() == "0") ? false : true;
      usesTestGateway = (currentRow["UsesTestGateway"].ToString() == "0") ? false : true;
      url = currentRow["Url"].ToString();
      requiresAuditing = (currentRow["RequiresAuditing"].ToString() == "0") ? false : true;
      requiresLogging = (currentRow["RequiresLogging"].ToString() == "0") ? false : true;
      correlationID = currentRow["CorrelationID"].ToString();
      status = (DocumentStatus)int.Parse(currentRow["Status"].ToString());
      lastPoll = (DateTime)currentRow["LastPoll"];
      nextPoll = (DateTime)currentRow["NextPoll"];
      gatewayResponse = currentRow["ResponseDocument"].ToString();
      }

    public bool InsertXmlUpdate(XmlDocument gtwDoc)
      {
      XmlNamespaceManager nsmgr = new XmlNamespaceManager(gtwDoc.NameTable);
      nsmgr.AddNamespace("env", "http://www.govtalk.gov.uk/CM/envelope");

      XmlNode currentNode = gtwDoc.SelectSingleNode("//env:Qualifier", nsmgr);
      string qualifier = currentNode.InnerText;

      switch (qualifier)
        {
        case "error":
          status = DocumentStatus.REJECTED;
          break;
        case "response":
          if (IsTestMessage || usesTestGateway)
            status = DocumentStatus.TESTCASE;
          else
            status = DocumentStatus.ACCEPTED;
          break;
        }

      currentNode = gtwDoc.SelectSingleNode("//env:CorrelationID", nsmgr);
      correlationID = currentNode.InnerText;

      currentNode = gtwDoc.SelectSingleNode("//env:ResponseEndPoint", nsmgr);
      url = currentNode.InnerText;
      string pollDelay = currentNode.Attributes[0].Value;

      currentNode = gtwDoc.SelectSingleNode("//env:GatewayTimestamp", nsmgr);
      string[] strTempDateTime = currentNode.InnerText.Split("/T-:.".ToCharArray());

      StringBuilder sb = new StringBuilder();
      sb.Append("/" + strTempDateTime[0]);
      sb.Insert(0, "/" + strTempDateTime[1]);
      sb.Insert(0, strTempDateTime[2]);
      sb.Append(" " + strTempDateTime[3] + ":");
      sb.Append(strTempDateTime[4] + ":");
      sb.Append(strTempDateTime[5]);

      lastPoll = DateTime.Parse(sb.ToString());

      // TODO Improve Polling mechanism
      nextPoll = lastPoll.AddSeconds(double.Parse(pollDelay));

      gatewayResponse = gtwDoc.OuterXml;

      return true;
      }
    public bool IsTestMessage
      {
      get { return isTestMessage; }
      set { isTestMessage = value; }
      }

    public bool UsesTestGateway
      {
      get { return usesTestGateway; }
      set { usesTestGateway = value; }
      }

    public bool RequiresLogging
      {
      get { return requiresLogging; }
      set { requiresLogging = value; }
      }

    public bool RequiresAuditing
      {
      get { return requiresAuditing; }
      set { requiresAuditing = value; }
      }

    public int ApplicationID
      {
      get { return applicationID; }
      set { applicationID = value; }
      }

    public int SubmissionID
      {
      get { return submissionID; }
      set { submissionID = value; }
      }

    public string Url
      {
      get { return url; }
      set { url = value; }
      }

    public string DocumentType
      {
      get { return documentType; }
      set { documentType = value; }
      }

    public string GatewayDoc
      {
      get { return gatewayDoc; }
      set { gatewayDoc = value; }
      }

    public string GatewayResponse
      {
      get { return gatewayResponse; }
      set { gatewayResponse = value; }
      }

    public string DocumentID
      {
      get { return documentID; }
      set { documentID = value; }
      }

    public string CorrelationID
      {
      get { return correlationID; }
      set { correlationID = value; }
      }
    public DateTime NextPoll
      {
      get { return nextPoll; }
      set { nextPoll = value; }
      }

    public DateTime LastPoll
      {
      get { return lastPoll; }
      set { lastPoll = value; }
      }
    }
  }
