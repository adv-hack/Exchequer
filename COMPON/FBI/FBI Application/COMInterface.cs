using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading;
using System.Xml;

namespace IRIS.Systems.InternetFiling
{

    internal struct ThreadParam
    {
       public ICallback callback;
       public GatewayDocument document;
       public string Guid;
       public int IntervalSeconds;

    }

   class PollingParameters
   {

      public PollingParameters(string guid, string Url, int IntervalSeconds)
      {
         _guid = guid;
         _url = Url;
         _intervalSeconds = IntervalSeconds;
      }
      
      private string _guid = "";
      public string Guid
      {
         get { return _guid; }
         set { _guid = value; }
      }

      private string _url = "";
      public string Url
      {
         get { return _url; }
         set { _url = value; }
      }

      private int _intervalSeconds = 0;
      public int IntervalSeconds      
      {
         get { return _intervalSeconds; }
         set { _intervalSeconds = value; }
      }


   }

    /// <summary>
   /// Interface used to define the COM interop
   /// </summary>
   [Guid("9C6E465B-E15D-4e3c-A65B-E777F89684E7")]
   [InterfaceType(ComInterfaceType.InterfaceIsIDispatch)]
   public interface IPosting
   {
       
        /// <summary>
        /// Add an IRMark 
        /// </summary>
        /// <param name="DocumentXml"></param>
        /// <param name="SubmissionType"></param>
        /// <returns></returns>
       string AddIRMark(ref string DocumentXml, int SubmissionType);
       string AddIRMark(ref string DocumentXml, string Namespace);

        string Submit(string Class,
							bool UsesTestGateway,
							string DocumentXml);

        void Query(int QueryNum);

        void SetConfiguration(string GatewayUrl);

        string BeginPolling(ICallback callback,
                        string CorrelationID,
                        string Class,
                        bool UsesTestGateway,
                        string GovTalkUrl);

        string BeginPolling(ICallback callback,
                        string CorrelationID,
                        string Class,
                        bool UsesTestGateway);

        string Delete(string CorrelationID,
                  string Class,
                  bool UsesTestGateway,
                  string GovTalkUrl);

        //Old Removed because not accessible over the COM boundary
        //XmlDocument  Delete(string CorrelationID,
        //          string Class,
        //          bool UsesTestGateway,
        //          string GovTalkUrl);

        void EndPolling(string PollerGuid);

        void RedirectPolling(string PollingGuid, string Redirect);

   }

   /// <summary>
   /// Class used as the COM gateway
   /// </summary>
    [Guid("54678DD0-6780-4a74-8786-0CE701FD85A7"),
    ClassInterface(ClassInterfaceType.AutoDual),
    ProgId("Iris_Internet_Filing"),
    Serializable,
    ComVisible(true)]
   public class Posting : IPosting
   {

      private const string _progID = "IRIS.Systems.InternetFiling";
      private string _programFiles = "";

      private string[] namespaces = new string[]{
         "http://www.govtalk.gov.uk/taxation/CTF",
         "http://www.govtalk.gov.uk/taxation/SA",
         "http://www.govtalk.gov.uk/taxation/EOY",
         "http://www.govtalk.gov.uk/taxation/CT/2",
         "http://www.govtalk.gov.uk/taxation/CISreturn",
         "http://www.govtalk.gov.uk/taxation/CISrequest"
         };



      public Posting()
      {
         PollingBrokerage.Log = null;
     }


      #region IPosting Members

      String _submissionUrl;        // 
      PollingBrokerage _broker = new PollingBrokerage();

      /// <summary>
      /// Add the IRMark to the file and return it to the calling app
      /// </summary>
      /// <param name="FileName"></param>
      /// <returns></returns>
      public string AddIRMark(ref string DocumentXml, int SubmissionType)
      {
          try
          {
              // Add in the IRMark
              // and return the IRMark as a string value)
              if (DocumentXml != null && DocumentXml != "")
              {
                  if (SubmissionType < namespaces.Length && SubmissionType >= 0)
                  {
                      string mark = IRMark32.AddIRMark(ref DocumentXml, namespaces[SubmissionType]);
                      return mark;
                  }
                  else
                  {
                      return "Not a valid submission type";
                  }
              }
              else
              {
                  return "No IRmark was generated";
              }
          }
          catch (Exception ex)
          {
              throw (ex);
          }

      }
      /// <summary>
      /// Add the IRMark to the file and return it to the calling app, Overloaded method to allow the passing in
      /// if the document type namespace directly.
      /// </summary>
      /// <param name="DocumentXml">A string representation of the whole document containing the Document type
      /// specified in the namespace paramter that requires the generation of the IR Mark</param>
      /// <param name="Namespace" > Namespace of the document type that requires the IR Mark</param>
      /// <returns></returns>
      public string AddIRMark(ref string DocumentXml, string  Namespace)
      {
          try
          {
              if (DocumentXml != null && DocumentXml != "")
              {
                  string mark = IRMark32.AddIRMark(ref DocumentXml, Namespace);
                  return mark;
              }
              else
              {
                  return "No IRmark was generated";
              }
          }
          catch (Exception ex)
          {
              throw (ex);
          }

      }

      /// <summary>
      /// Submit the document to the government gateway.
      /// Returns the Xml from the GatewayServer, or an empty
      /// string if nothing to submit.
      /// </summary>
      public string Submit(string Class,
                     bool UsesTestGateway,
                     string DocumentXml)
      {
         if (DocumentXml != null && DocumentXml != "") {
            GatewayDocument submission = new GatewayDocument();          // The Posting settings must be applied first.

            // Assign posting settings.
            submission.Url = _submissionUrl;

            //... and fill in the fields ...
            submission.DocumentType = Class;
            submission.UsesTestGateway = UsesTestGateway;

            // Stuff the XML into the document
            submission.GatewayDoc = DocumentXml;

            // Submit the document
            XmlDocument returnDoc = GatewayServer.Submit(submission);

            // return the generated Xml
            return returnDoc.OuterXml;

         }
         else {
            // Nothing to do
            return "";
         }

         
      }

      public void Query(int QueryNum)
      {
         // Do something to kill the warning
         QueryNum++;
         return;
      }

      public void SetConfiguration(string GatewayUrl)
      {
          try
          {
              // Set the server for a new submission cycle.
              _submissionUrl = GatewayUrl;
          }
          catch (Exception ex)
          {
              throw (ex);
          }

      }

      public string BeginPolling(ICallback callback,
                        string CorrelationID,
                        string Class,
                        bool UsesTestGateway,
                        string GovTalkUrl,
                        int PollingIntervalWholeSeconds)
      {
          string RetVal;
         // HACK: Temp just call back the response if the correlation ID is "-999"
         if (CorrelationID == "-999")
         {
             callback.Response("This is a test call back from the FBI COM Object 8.8.1.2");
             return ("Test call back was performed");
         }
         else
         {
             try
             {
                 RetVal = _broker.BeginPolling(callback,
                                   CorrelationID,
                                   Class,
                                   UsesTestGateway,
                                   GovTalkUrl, PollingIntervalWholeSeconds);
             }
             catch (Exception ex)
             {
                 throw (ex);
             }

             return RetVal;

         }
          
      }

      public string BeginPolling(ICallback callback,
                        string CorrelationID,
                        string Class,
                        bool UsesTestGateway,
                        string GovTalkUrl)
      {
         return _broker.BeginPolling(callback,
                            CorrelationID,
                            Class,
                            UsesTestGateway,
                            GovTalkUrl, 60);
     }

      public string BeginPolling(ICallback callback,
                        string CorrelationID,
                        string Class,
                        bool UsesTestGateway)
      {
          return _broker.BeginPolling(callback,
                                 CorrelationID,
                                 Class,
                                 UsesTestGateway,
                                 "", 60);

     }



       public string Delete(string CorrelationID,
                   string Class,
                   bool UsesTestGateway,
                   string GovTalkUrl)
       {
           XmlDocument DeleteResponse;
           GatewayDocument gwDoc = new GatewayDocument();

           gwDoc.CorrelationID = CorrelationID;
           gwDoc.UsesTestGateway = UsesTestGateway;
           gwDoc.DocumentType = Class;
           gwDoc.Url = GovTalkUrl;

           DeleteResponse = GatewayServer.Delete(gwDoc);
           return DeleteResponse.OuterXml ;

       }

      public XmlDocument RequestList(string CorrelationID,
                  string Class,
                  bool UsesTestGateway,
                  string GovTalkUrl)
      {
         GatewayDocument gwDoc = new GatewayDocument();

         gwDoc.CorrelationID = CorrelationID;
         gwDoc.UsesTestGateway = UsesTestGateway;
         gwDoc.DocumentType = Class;
         gwDoc.Url = GovTalkUrl;

         return GatewayServer.RequestList(gwDoc);
      }

      public void EndPolling(string PollerGuid)
      {
          try
          {
              // Terminate the thread
              _broker.EndPolling(PollerGuid);

              // remove the parameters from the dictionary
              _broker.Parameters.Remove(PollerGuid);
          }
          catch (Exception ex)
          {
              throw (ex);
          }

      }


      public void RedirectPolling(string PollingGuid, string Redirect)
      {
          try
          {
              _broker.RedirectPolling(PollingGuid, Redirect, 20);
          }
          catch (Exception ex)
          {
              throw (ex);
          }

      }

      #endregion
   }

   /// <summary>
   /// Interface used to define the callback class
   /// </summary>
    [Guid("2BB4A16E-6EA5-4837-80C1-B01DD4345ECD"),
      InterfaceType(ComInterfaceType.InterfaceIsDual),
      ComVisible(true)]
   public interface ICallback
   {
      void Response(string message);

      void _Unused();

   }

   /// <summary>
   /// Container class used as a type definition for an unmanaged
   /// variable
   /// </summary>
    [Guid("7C7D8AA9-0B4F-4f0f-A5C3-68E1657AF4C5"),
      ClassInterface(ClassInterfaceType.AutoDual),
      ProgId("CallbackContainer"),
      Serializable,
      ComVisible(true)]
   public class CallbackContainer : ICallback
   {

      #region ICallback Members

       public virtual void Response(string message) { }

       void ICallback._Unused() { }

      #endregion
   }


   #region Non-exposed classes
   // Classes in this region are used as internal brokers only by the 
   // COM interface classes. These cannot be exposed over the COM boundary

   /// <summary>
   /// This class serves as the monitor brokerage for the 
   /// </summary>
   internal class PollingBrokerage
   {

      private bool _brokerRunning = false;                                                            // Keeps the broker running the active threads
      private static EventLog _eventLog = new EventLog();                                             
      private Dictionary<string, Thread> _threadDump = new Dictionary<string, Thread>();              // Contains the active threads
      private Dictionary<string, ThreadParam> _parameters = new Dictionary<string, ThreadParam>();    // Contains the parameters for the active threads

      public Dictionary<string, ThreadParam> Parameters
      {
         get { return _parameters; }
      }

      // Constructor
      public void StartThreadManager()
      {
         _brokerRunning = true;

         /* 
          * Sleep this main thread while the broker is 
          * running to allow the child threads to execute;
          */
         do {
            Thread.Sleep(0);
            // MAG Removing Event Log Stuff _eventLog.WriteEntry(string.Format("Parent thread active"));
         } while (_brokerRunning);

      }


      /// <summary>
      /// Reverved for future use, unused
      /// </summary>
 
      public static EventLog Log
      {
         get
         {
            if (_eventLog == null)
               _eventLog = new EventLog();

            return _eventLog;
         }
         set
         {
            _eventLog = value;
         }
      }

      /// <summary>
      /// Flags the system to end the broker on the next idle loop
      /// </summary>
       public void EndBroker()
      {
         _brokerRunning = false;
      }

      /// <summary>
      /// Begins polling the government gateway on a new thread
      /// </summary>
      /// <param name="callback"></param>
      /// <returns></returns>
       internal string BeginPolling(ICallback callback, // Was CallbackContainer
                        string CorrelationID,
                        string Class,
                        bool UsesTestGateway,
                        string GovTalkUrl,
                        int IntervalSeconds)
      {
         // Generate an identifier for the polling instance
         string threadGuid = System.Guid.NewGuid().ToString();

         // Generate the new thread
         return CreatePollingThread(callback, CorrelationID, Class, UsesTestGateway, GovTalkUrl, threadGuid, IntervalSeconds);
      }

       internal string CreatePollingThread(ICallback callback, // Was CallbackContainer
                        string CorrelationID,
                        string Class,
                        bool UsesTestGateway,
                        string GovTalkUrl,
                        string Guid,
                        int IntervalSeconds)
      {
         // Begin constructing the gateway document to poll for
         GatewayDocument submission = new GatewayDocument();
         
         //... and fill in the fields ...
         submission.DocumentID = "";
         submission.ApplicationID = 0;
         submission.CorrelationID = CorrelationID;
         submission.DocumentType = Class;
         submission.IsTestMessage = false;
         submission.UsesTestGateway = UsesTestGateway;
         submission.RequiresAuditing = false;
         submission.RequiresLogging = false;
         
         // Only replace the default if the supplied parameter is 
         // not an empty string
         if (GovTalkUrl!="")
            submission.Url = GovTalkUrl;
         
         /*
          * Kick off a new thread; we have to be a little type un-safe here
          * because of the limitations of the parameterised ThreadStart
          * But that's OK because we've unforced the type in the call.
          */
          ThreadParam parameters = new ThreadParam();
          parameters.callback = callback;
          parameters.document = submission;
          parameters.Guid = Guid;
          parameters.IntervalSeconds = IntervalSeconds;

         Thread pollingThread = new Thread(new ParameterizedThreadStart(RunPollingThread));

         pollingThread.Start(parameters);

         if (_parameters.ContainsKey(Guid))
            _parameters.Remove(Guid);

         _parameters.Add(Guid, parameters);

         // Register and reeeeee-eeeeeee-eeeeee-turn
         _threadDump.Add(Guid, pollingThread);
         return Guid;
      }
      
      /// <summary>
      /// Suspends a particular thread and 
      /// ends the polling session
      /// </summary>
      /// <param name="Guid"></param>
      internal void EndPolling(string Guid)
      {
         // Cycle through the loop, looking for the thread,
         // end it and remove it from the dictionary
          try {
             foreach (KeyValuePair<string, Thread> entry in _threadDump)
                if (entry.Key == Guid) {
                   try {
                      PollingBrokerage._messages.Add(new PollingParameters(Guid, "", -1));
                   }
                   catch // (System.Exception exception)
                   {
                   }
                   _threadDump.Remove(entry.Key);
                   return;
                }
          }
          catch // (ThreadAbortException ex)
          {
          }
      }


      internal static List<PollingParameters> _messages = new List<PollingParameters>();

      /// <summary>
      /// Adds a message to the volatile message queue
      /// </summary>
      /// <param name="Guid"></param>
      /// <param name="RedirectedUrl"></param>
      internal void RedirectPolling(string Guid, string RedirectedUrl, int IntervalSeconds)
      {
         PollingBrokerage._messages.Add(new PollingParameters(Guid, RedirectedUrl, IntervalSeconds));
      }

      /// <summary>
      /// Provides the meat of the polling mechanism.
      /// </summary>
      internal static void RunPollingThread(object Parameters)
      {
          try
          {

              // Prepare the thread for execution
              ICallback callback = ((ThreadParam)Parameters).callback;
              GatewayDocument gwDoc = ((ThreadParam)Parameters).document;

              if (callback == null)
              {
                  // MAG Removing Event Log Stuff _eventLog.WriteEntry(string.Format("Callback is null"));
                  return;
              }
              int interval = ((ThreadParam)Parameters).IntervalSeconds;
              // Make sure the thread is always running, occasionally sleeping
              XmlDocument returnDoc;
              bool threadRunning = true;
              do
              {

                  // Check for redirection information
                  foreach (PollingParameters param in _messages)
                  {
                      if (param.Guid == ((ThreadParam)Parameters).Guid)
                      {
                          // rather than using the Parameters paramerter, should we be using the param for the test, 
                          // so the thread actually stops?
                          if (param.Url == "" && param.IntervalSeconds < 0)
                          {
                              threadRunning = false;
                              _messages.Remove(param);
                              return;
                          }


                          // Will redirect to the first message in the queue, then delete it
                          ((ThreadParam)Parameters).document.Url = param.Url;
                          interval = ((ThreadParam)Parameters).IntervalSeconds;
                          _messages.Remove(param);
                          break;
                      }
                  }

                  // Poll...
                  returnDoc = GatewayServer.Poll(gwDoc);

                  if (returnDoc == null)
                  {
                  }
                  else
                  {

                      // A response has been received, so check the message for any redirection or poll interval changes, and 
                      // implement those changes
                      XmlNodeList ResponseParams = returnDoc.GetElementsByTagName("ResponseEndPoint");

                      try
                      {
                          // Get the polling interval and set out internal timer, and the interval in the thread parameters
                          interval = Convert.ToInt32(ResponseParams[0].Attributes["PollInterval"].InnerText);
                      }
                      catch (Exception)
                      {
                          interval = 60; // the default
                      }

                      try
                      {
                          // Now redirect as well
                          ((ThreadParam)Parameters).document.Url = ResponseParams[0].InnerText;
                      }
                      catch (Exception)
                      {
                          // Nothing to do leave it as it is
                      }

                      // Invoke the callback
                      callback.Response(returnDoc.InnerXml);

                  }
                  // Pause until the next polling period
                  Thread.Sleep(interval * 1000);



              } while (threadRunning);

          }
          catch (Exception ex)
          {
              throw (ex);
          }


      }
   }

   #endregion
}
