using System;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Sockets;
using System.Reflection;
using System.ServiceModel;
using System.ServiceModel.Web;
using System.ServiceProcess;
using System.Diagnostics;

// using System.Collections.Generic;
// using System.ComponentModel;
// using System.Data;
// using System.Text;
// using System.Threading.Tasks;
// using System.ServiceModel.Description;

namespace HMRCFilingService
  {
  public partial class HMRCFilingService : ServiceBase
    {
//    public const string logName = "HMRCFilingServiceLog";
//    public const string logSource = "HMRCFilingService";

    public const string server = @"localhost";
    public const int port = 64193;
    public static string cmd = string.Empty;

    private string appPath = string.Empty;

    // Database handler
    private VAT100Database dbHandler = null;

    // PKR. 07/09/2015. ABSEXCH-16768
    private WebServiceHost host;
    private WebChannelFactory<IHMRCFilingService> cf;
    private Uri baseAddress = new Uri(string.Format("http://{0}:{1}/", server, port.ToString()));

    private UpdateChecker refresher;

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Constructor
    /// </summary>
    public HMRCFilingService()
      {
      InitializeComponent();

      appPath = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);

      Logger.Log("HMRC Filing Service", false); // Start a new log file by specifying append = false.
      Logger.Log("===================");

#if DEBUG
      Logger.Log("HMRCFilingService is hosted at : " + baseAddress.AbsoluteUri);
#endif
      // Create a database handler
      try
        {
      // PKR. 24/09/2015. ABSEXCH-16919.
      // Services don't know about mapped drives as they are not created until a user logs in
      // So we read them from an INI file and map them locally to the service.
      // Read the list of mapped drives from the INI file
#if DEBUG
      Logger.Log("Checking mapped drives");
#endif
      string[] mappedDrives;
      if (System.IO.File.Exists(Path.Combine(appPath, "MappedDrives.ini")))
        {
#if DEBUG
        Logger.Log("Opening MappedDrives.ini");
#endif
        mappedDrives = System.IO.File.ReadAllLines(Path.Combine(appPath, "MappedDrives.ini"));

        foreach (string mappedDrive in mappedDrives)
          {
          string[] exploder = mappedDrive.Split('=');
          if (exploder.Count() > 1)
            {
            // Get the drive letter. This doesn't have a trailing backslash,
            //  but the mcmDrive letter does.
            string mapDrive = exploder[0];

            // If the mapped drive already exists, ignore it.
            if (!Directory.Exists(mapDrive))
              {
              // Get the UNC path
              string UNCpath = exploder[1];
              // Strip trailing backslashes because MapNetworkDrive doesn't like them.
              UNCpath = UNCpath.TrimEnd(new[] { '/', '\\' });

              MapNetworkDrive(mapDrive, UNCpath);

              if (!Directory.Exists(mapDrive))
                {
                // Mapping failed
                Logger.Log("Could not map drive " + mapDrive + " to " + UNCpath);
                }
              else
                {
                Logger.Log("Mapped drive " + mapDrive + " to " + UNCpath);
                }
              }
            }
          } // foreach mapped drive
        }
      else
        {
        Logger.Log("Couldn't find mapped drive list");
        }

      dbHandler = VAT100Database.Instance;

#if DEBUG
      string epath = dbHandler.tToolkit.Configuration.EnterpriseDirectory;
      FileVersionInfo tkFVI = FileVersionInfo.GetVersionInfo(Path.Combine(epath, "EntToolk.exe"));
      Logger.Log("COM Toolkit version : " + tkFVI.FileVersion);
#endif
        }
      catch (Exception ex)
        {
        Logger.Log("Error getting dbHandler : " + ex.Message);
        Logger.Log(VAT100Database.GetLastErrorString());
        }

#if DEBUG
      Logger.Log("Setting WebServiceURL");
#endif
      SetWebServiceURL();
      }

    //---------------------------------------------------------------------------------------------
    protected override void OnStart(string[] args)
      {
      //WebServiceHost will automatically create a default endpoint at the base address using the
      //WebHttpBinding and the WebHttpBehavior, so there's no need to set that up explicitly
      try
        {
        baseAddress = new Uri(string.Format("http://{0}:{1}/", server, port.ToString()));
#if DEBUG
        Logger.Log("Service OnStart: baseAddress = " + baseAddress.AbsoluteUri);
#endif

        host = new WebServiceHost(typeof(HMRCFilingServiceProcessor), baseAddress);
        if (host == null)
          {
#if DEBUG
          Logger.Log("Could not create Web Service Host");
#endif
          }
        else
          {

#if DEBUG
          Logger.Log("Opening host");
#endif

          host.Open();

          cf = new WebChannelFactory<IHMRCFilingService>(baseAddress);

          if (cf == null)
            {
#if DEBUG
            Logger.Log("Null channel factory");
#endif
            }
          else
            {
            IHMRCFilingService channel = cf.CreateChannel();

            if (channel != null)
              {
#if DEBUG
              Logger.Log("Host channel opened");
#endif
              }
            else
              {
              Logger.Log("Failed to create channel");
              }
            }
          }
        } // end try
      catch (AggregateException aggEx)
        {
        String bigMessage = "The following errors occurred";

        for (int index = 0; index < aggEx.InnerExceptions.Count; index++)
          {
          bigMessage += "\r\n" + UnwindException(aggEx.InnerExceptions[index]);
          }

        Logger.Log(bigMessage);
        }
      catch (Exception ex)
        {
        Logger.Log(ex.Message);
        // Get the inner exceptions, if there are any
        Exception iex = ex.InnerException;
        while (iex != null)
          {
          iex = iex.InnerException;
          Logger.Log(iex.Message);
          }
        }

#if DEBUG
      Logger.Log("Creating updater...");
#endif
      try
        {
        refresher = new UpdateChecker();
        }
      catch (Exception ex)
        {
        Logger.Log(ex.Message);
        }
      } // OnStart()

    //---------------------------------------------------------------------------------------------
    protected override void OnStop()
      {
      try
        {
        Logger.Log("Closing service");
        }
      finally
        {
        // Free the resources
        baseAddress = null;
        host.Close();
        host = null;
        cf = null;
        }
      }

    //---------------------------------------------------------------------------------------------
    private static void ShowHostStatus(WebServiceHost host)
      {
      switch (host.State)
        {
        case CommunicationState.Closed:
          Console.WriteLine("Host State is 'Closed'");
          break;

        case CommunicationState.Closing:
          Console.WriteLine("Host State is 'Closing'");
          break;

        case CommunicationState.Created:
          Console.WriteLine("Host State is 'Created'");
          break;

        case CommunicationState.Faulted:
          Console.WriteLine("Host State is 'Faulted'");
          break;

        case CommunicationState.Opened:
          Console.WriteLine("Host State is 'Opened'");
          break;

        case CommunicationState.Opening:
          Console.WriteLine("Host State is 'Opening'");
          break;
        }
      }

    //---------------------------------------------------------------------------------------------
    private static string UnwindException(Exception Ex)
      {
      string finalMessage = string.Empty;
      Exception subEx = Ex;
      while (subEx.InnerException != null)
        {
        subEx = subEx.InnerException;
        }

      finalMessage = subEx.Message;
      if (string.IsNullOrEmpty(finalMessage))
        {
        finalMessage = "An unknown error occurred";
        }

      return finalMessage;
      }

    //---------------------------------------------------------------------------------------------
    /// <summary>
    /// Determines the IP address for this machine and stores it in an INIfile
    /// so that it is available to any instances of Exchequer which need to
    /// access the web-service.
    /// </summary>
    private void SetWebServiceURL()
      {
      IPHostEntry host;
      string localIP = "?";

      try
        {
        host = Dns.GetHostEntry(Dns.GetHostName());

#if DEBUG
        if (host == null)
          {
          Logger.Log("SetWebServiceURL: host is null");
          }
        else
          {
          Logger.Log("SetWebServiceURL: host = " + host.HostName);
          }
#endif

        foreach (IPAddress ip in host.AddressList)
          {
          if (ip.AddressFamily == AddressFamily.InterNetwork)
            {
            localIP = ip.ToString();
            }
          }
        }
      catch (Exception ex)
        {
        Logger.Log("SetWebServiceURL exception : " + ex.Message);
        }

      string filespec = string.Empty;
      try
        {
#if DEBUG
        if (dbHandler == null)
          {
          Logger.Log("    dbHandler is null");
          }
        else
          {
          Logger.Log("    dbHandler ok");
          if (dbHandler.tToolkit == null)
            {
            Logger.Log("      toolkit is null");
            }
          else
            {
            Logger.Log("      toolkit ok");
            if (dbHandler.tToolkit.Configuration == null)
              {
              Logger.Log("        Configuration is null");
              }
            else
              {
              Logger.Log("        Configuration ok");
              if (dbHandler.tToolkit.Configuration.EnterpriseDirectory == null)
                {
                Logger.Log("          EnterpriseDirectory is null");
                }
              else
                {
                Logger.Log("          EnterpriseDirectory ok");
                }
              }
            }
          }
#endif

        filespec = Path.Combine(dbHandler.tToolkit.Configuration.EnterpriseDirectory, @"HMRC Filing Service\HMRCFiling.ini");
        }
      catch(Exception ex)
        {
        Logger.Log("SetWebServiceURL error getting filespec : " + ex.Message);
        }

      Logger.Log("Filing service " + localIP);

      // WriteAllText creates a file, writes the specified string to the file,
      // and then closes the file.
      try
        {
        System.IO.File.WriteAllText(filespec, string.Format("[WebService]\r\nURL={0}", localIP));
        }
      catch (Exception ex)
        {
        Logger.Log("HMRCFilingService : Failed to save file ["+ filespec +"]\r\n" + ex.Message);
        }
      }

    //---------------------------------------------------------------------------------------------
    public void MapNetworkDrive(string driveLetter, string path)
      {
      NetworkDrive oNetDrive = new NetworkDrive();

      oNetDrive.LocalDrive = driveLetter;
      oNetDrive.Persistent = true;
      oNetDrive.ShareName = path;
      oNetDrive.Force = true;

      try
        {
        oNetDrive.MapDrive();
        }
      catch(Exception ex)
        {
        Logger.Log("Error mapping drive " + driveLetter + ".\r\n" + ex.Message);
        }
      }
    }
  }