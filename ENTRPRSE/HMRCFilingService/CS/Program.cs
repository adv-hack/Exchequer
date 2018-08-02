using System;
using System.Collections.Generic;
using System.Linq;
using System.ServiceProcess;
using System.Text;
using System.Threading.Tasks;
using System.Configuration.Install;
using System.IO;
using System.Reflection;
using Microsoft.Win32;

namespace HMRCFilingService
  {
  static class Program
    {
    static string thisPath;
    /// <summary>
    /// The main entry point for the application.
    /// </summary>
    static void Main(string[] args)
      {
      thisPath = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);

      // PKR. 07/09/2015. ABSEXCH-16768
      // The installer/uninstaller runs this program with the --install or --uninstall parameter.
      // This sets the UserInteractive mode
      if (System.Environment.UserInteractive)
        {
        string parameter = string.Concat(args);
        // PKR. 22/09/2015. Added timeout to service Start/Stop calls.
        TimeSpan timeout = new TimeSpan(0, 0, 10);
        switch (parameter)
          {
          case "--install":
            // Check if .NET 4.5.2 or higher installed.  (Looks for Registry entries, so could still fail if the .NET installation is corrupted)
            if (!isMinimumDotNetInstalled("4.5.2"))
              {
              Logger.Log("Cannot install HMRC Filing Service.");
              Logger.Log(".NET 4.5.2 or higher required.");
              }
            else
              {
              // This does the job of InstallUtil.exe HMRCFilingService.exe
              ManagedInstallerClass.InstallHelper(new string[] { Assembly.GetExecutingAssembly().Location });

              // The assembly is configured as Automatic.  However, that only applies at startup.
              // So after installation, we have to force the service to start.
              using (ServiceController sci = new ServiceController("HMRCFilingService"))
                {
                // If the service status isn't "Running", then stop it.
                if (!sci.Status.Equals(ServiceControllerStatus.Running))
                  {
                  try
                    {
                    sci.Start();
                    sci.WaitForStatus(System.ServiceProcess.ServiceControllerStatus.Running, timeout);
                    }
                  catch (Exception ex)
                    {
                    string exMsg = string.Format("{0} An error occurred starting the HMRC Filing Service :\r\n{1}", DateTime.Now.ToString(), ex.Message);
                    Logger.Log(exMsg);
                    }
                  }
                }
              }
            break;

          case "--installonly":
            // This does the job of InstallUtil.exe HMRCFilingService.exe
            ManagedInstallerClass.InstallHelper(new string[] { Assembly.GetExecutingAssembly().Location });
            break;

          case "--uninstall":
            using (ServiceController scu = new ServiceController("HMRCFilingService"))
              {
              // If the service status isn't "Stopped", then stop it.
              if (!scu.Status.Equals(ServiceControllerStatus.Stopped))
                {
                try
                  {
                  scu.Stop();
                  scu.WaitForStatus(System.ServiceProcess.ServiceControllerStatus.Stopped, timeout);
                  }
                catch (Exception ex)
                  {
                  string exMsg = string.Format("{0} An error occurred stopping the HMRC Filing Service :\r\n{1}", DateTime.Now.ToString(), ex.Message);
                  Logger.Log(exMsg);
                  }
                }
              }

            // This does the job of InstallUtil.exe /u HMRCFilingService.exe
            ManagedInstallerClass.InstallHelper(new string[] { "/u", Assembly.GetExecutingAssembly().Location });
            break;
          }
        }
      else
        {
        // Normal running mode
        ServiceBase[] ServicesToRun;
        ServicesToRun = new ServiceBase[] 
          { 
          new HMRCFilingService() 
          };
        ServiceBase.Run(ServicesToRun);
        }
      }

    //---------------------------------------------------------------------------------------------
    private static bool isMinimumDotNetInstalled(string aVersion)
      {
      bool Result = false;
      using (RegistryKey ndpKey = RegistryKey.OpenBaseKey(RegistryHive.LocalMachine, RegistryView.Registry32).OpenSubKey("SOFTWARE\\Microsoft\\NET Framework Setup\\NDP\\v4\\Full\\"))
        {
        int releaseKey = Convert.ToInt32(ndpKey.GetValue("Release"));

        switch (aVersion)
          {
          case "4.5":
            Result = (releaseKey >= 378389); // 4.5
            break;
          case "4.5.1":
            Result = (releaseKey >= 378675); // 4.5.1
            break;
          case "4.5.2":
            Result = (releaseKey >= 379893); // 4.5.2
            break;
          case "4.6":
            Result = (releaseKey >= 393295); // 4.6
            break;
          }
        }
      return Result;
      }

    }
  }
