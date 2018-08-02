using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.ServiceProcess;
using System.Text;
using System.Runtime.Remoting;
using System.Runtime.Remoting.Channels;
using System.Runtime.Remoting.Channels.Tcp;
using System.Configuration;
using IRIS.ICE.Common;


namespace WrapperDSRServer
{
    public partial class WrapperDSRServer : ServiceBase
    {
        

        #region Private Members

        private TcpServerChannel _tcpServer;

        #endregion

        public WrapperDSRServer()
        {
            InitializeComponent();
        }

        protected override void OnStart(string[] args)
        {
            DebugFileCtrl debug = new DebugFileCtrl(false);

            if (args.Length > 0)
            {
                if (args[0].ToUpper().Equals("WITHLOG"))
                    Program.LogEvents = true;
            }

            try
            {

                // Set up the Remoting channel
                if (Program.LogEvents)
                {
                    debug.WriteLog("STARTING DSR WRAPPER SERVICE");
                    debug.WriteLog("About to create TCP server channel on " + ConfigurationManager.AppSettings["PortNumber"].ToString());
                }
                _tcpServer = new TcpServerChannel(Convert.ToInt32(ConfigurationManager.AppSettings["PortNumber"]));
                
                if (Program.LogEvents)
                    debug.WriteLog("About to register TCP server channel");
                
                ChannelServices.RegisterChannel(_tcpServer, false);

                if (Program.LogEvents)
                    debug.WriteLog("About to register well known service type: IWrapperDSR");
                
                RemotingConfiguration.RegisterWellKnownServiceType(typeof(WrapperDSR), "WrapperDSR", WellKnownObjectMode.Singleton);

                GlobalDSR.DsrInitialize();

                

            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (OnStart): " + err.Message);
            }
        }

        protected override void OnStop()
        {
            DebugFileCtrl debug = new DebugFileCtrl(false);
            try
            {
                // Tear down the remoting channel
                if (Program.LogEvents)
                    debug.WriteLog("About to unregister TCP server channel");
                
                ChannelServices.UnregisterChannel(_tcpServer);

                if (Program.LogEvents)
                {
                    debug.WriteLog("Channel unregistered successfully");
                    debug.WriteLog("STOPPING DSR WRAPPER SERVICE");
                }
            }
            catch (System.Exception err)
            {
                debug.WriteLog("EXCEPTION (OnStop): " + err.Message);
            }
        }
    }
}
