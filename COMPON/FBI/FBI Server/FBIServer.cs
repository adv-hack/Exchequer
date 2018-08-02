using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Diagnostics;
using System.IO;
using System.Runtime.Remoting;
using System.Runtime.Remoting.Channels;
using System.Runtime.Remoting.Channels.Tcp;
using System.Threading;
using System.Xml;

namespace IRIS.Systems.InternetFiling
{
    /// <summary>
    /// This appears to be the remoting components of the
    /// Internet Filing subsystem
    /// </summary>
    public class FBIServer
    {
        private TcpServerChannel channel;
        private Thread postThread;
        private Mutex qMutex = new Mutex();
        private int port = 0;
        private GatewayDocuments gatewayDB;

        public FBIServer()
        {
            
            Trace.WriteLine("FBIServer constructor called");

            Trace.WriteLine("Building DB object");    
            gatewayDB = new GatewayDocuments();

            Trace.WriteLine("Starting posting thread");
            postThread = new Thread(PostThread);
            postThread.Start();

        }

        public bool OpenChannel ()
        {
            if (port == 0)
                port = 8089;
            Trace.WriteLine("About to register TCP channel on port " + port);
            channel = new TcpServerChannel(port);

            // ABSEXCH-14471.  PKR. 29/07/2013.
            // Components rebuilt in VS2008.  The following call is obsolete in .NET 2.0 and above.
            // Replaced with recommended alternative.

            // ChannelServices.RegisterChannel(channel);
            ChannelServices.RegisterChannel(channel, true);

            RemotingConfiguration.RegisterWellKnownServiceType(
                    typeof(IFBIServer), "iris_fbi", WellKnownObjectMode.SingleCall);

            Trace.WriteLine("Registered TCP channel on port " + port + " successfully");
            
            return true;
        }

        public bool CloseChannel()
        {
            Trace.WriteLine("Closing Remoting Channel");
            try
            {
                ChannelServices.UnregisterChannel(channel);
            }
            catch (RemotingException ex)
            {
                Trace.WriteLine("There was an exception while closing the remote channel");
                Trace.WriteLine("The exception was:");
                Trace.WriteLine(ex.Message);
                channel = null;
                return false;
            }
            channel = null;
            return true;
        }

        ~FBIServer()
        {
            Trace.WriteLine("FBIServer destructor called");
        }

        public int Submit(GatewayDocument gatewayDoc)
        {
            Trace.WriteLine("Got Submission. GatewayDocument object");

            if (gatewayDoc.GatewayDoc == null)
            {
                Trace.WriteLine("Xml Message not present. Returning 0");
                return 0;
            }

            int response = 0;
            response = gatewayDB.InsertDocument(gatewayDoc);

            Trace.WriteLine("Thread is in state: " + postThread.ThreadState.ToString());

            if (postThread.ThreadState == System.Threading.ThreadState.Stopped)
            {
                Trace.WriteLine("Starting posting thread");
                postThread = new Thread(PostThread);
                postThread.Start();
            }

            return response;
        }

        public int Query(int num)
        {
            return 0;
        }

        private void PostThread()
        {
            Trace.WriteLine("Got into Processing Thread " + Thread.CurrentThread.ManagedThreadId);

            List<GatewayDocument> gatewayDocList = gatewayDB.GetDocumentsWithStatus(DocumentStatus.NOSTATUS);
            
            while (gatewayDocList.Count > 0)
            {
                Trace.WriteLine("Documents in Posting Queue");

                foreach (GatewayDocument gDoc in gatewayDocList)
                {
                    Trace.WriteLine("About to send Document " + gDoc.SubmissionID);

                    gatewayDB.SetStatus(gDoc.SubmissionID, DocumentStatus.SUBMITTING);

                    XmlDocument gtwResponse = GatewayServer.Submit(gDoc);

                    if (gtwResponse != null)
                    {
                        if (gDoc.InsertXmlUpdate(gtwResponse))
                        {
                            Trace.WriteLine("XML Response from Gateway for document " + gDoc.SubmissionID +
                                " was imported sucessfully into GatewayDocument. Writing to Database");
                            gatewayDB.UpdateDocument(gDoc);
                            gatewayDB.SetStatus(gDoc.SubmissionID, DocumentStatus.POLLING);
                        }
                        else
                        {
                            Trace.WriteLine("GatewayDocument " + gDoc.SubmissionID + 
                                " could not be saved to the database");
                        }
                    }
                    else
                    {
                        gatewayDB.SetStatus(gDoc.SubmissionID, DocumentStatus.UNKNOWN);
                        break;
                    }
                }

                gatewayDocList = gatewayDB.GetDocumentsWithStatus(DocumentStatus.NOSTATUS);
            }

            Trace.WriteLine("Posting Queue is empty. Exiting Posting Thread");
        }

        public int Port
        {
            get { return port; }
            set { port = value; }
        }
	
    }
}

