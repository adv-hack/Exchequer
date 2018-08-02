using System;
using System.Diagnostics;
using System.IO;
using System.ServiceProcess;
using System.Reflection;
using System.Threading;

namespace GUUConsole
{
    internal class Program
    {
        static private string srcDir = string.Empty;
        static private string destDir = string.Empty;
        static private string thisAppName;
        static private string thisPath;

        private static void Main(string[] args)
        {
            string status = "successfully";

            Log("GUU started", false);

            try
            {
                thisAppName = Path.GetFileName(System.Reflection.Assembly.GetExecutingAssembly().Location);

                if (args.Length < 2)
                {
                    Log("Usage:\r\nGUU.exe <sourcedirectory> <destinationdirectory>");
                }
                else
                {
                    int argNum = 0;
                    foreach (string arg in args)
                    {
                        if (argNum == 0)
                            srcDir = arg;
                        if (argNum == 1)
                            destDir = arg;
                        argNum++;
                    }
                }
            }
            catch (Exception ex)
            {
                Log("Exception getting arguments : " + ex.Message);
            }

            // Process the update.  This will later be replaced by a script-driven system,
            // so each step is handled by an appropriate function

            int Res = 0;

            // Stop the HMRC service
            Res = StopService("HMRCFilingService");
            if (Res == 0)
            {
                // Copy the files from the source to the destination
                Res = CopyHMRCFiles(srcDir, destDir);
                if (Res == 0)
                {
                    // Start the HMRC Service
                    Res = StartService("HMRCFilingService");
                    if (Res != 0)
                    {
                        // Couldn't start the service
                        Log("GUU.exe couldn't start the service");
                        status = "with errors";
                    }
                }
                else
                {
                    // Failed to copy the files
                    Log("GUU.exe couldn't update the files");
                    status = "with errors";
                }
            }
            else
            {
                // Couldn't stop the service
                Log("GUU.exe couldn't stop the service");
                status = "with errors";
            }

            Log("GUU update finished " + status);
        }

        //---------------------------------------------------------------------------------------------
        private static int StopService(string aServicename)
        {
            int Result = 0;

            Log("Stopping service " + aServicename + "...\r\n");

            try
            {
                ServiceController service = new ServiceController(aServicename);
                TimeSpan timeout = new TimeSpan(0, 0, 10);

                if (service.Status != ServiceControllerStatus.Stopped)
                {
                    service.Stop();
                }

                Log("Waiting for service to stop");

                service.WaitForStatus(ServiceControllerStatus.Stopped); //, timeout);
            }
            catch (InvalidOperationException ex)
            {
                Log("Invalid Operation " + ex.Message);

                Result = 1;
            }
            catch (Exception ex)
            {
                Log("Error stopping " + aServicename + "\r\n" + ex.Message + "\r\n");
                Result = 2;
            }

            if (Result == 0)
                Log("Service stopped.\r\n");
            if (Result == 1)
            {
                Log("Service not running on this computer.\r\n");
                Result = 0;
            }

            return Result;
        }

        //---------------------------------------------------------------------------------------------
        private static int StartService(string aServicename)
        {
            int Result = 0;

            Log("Starting service " + aServicename + "...\r\n");

            ServiceController service = new ServiceController(aServicename);
            try
            {
                TimeSpan timeout = new TimeSpan(0, 0, 10);

                if (service.Status != ServiceControllerStatus.Running)
                {
                    service.Start();
                }
                service.WaitForStatus(ServiceControllerStatus.Running, timeout);
            }
            catch (InvalidOperationException ex)
            {
                Log("Error starting " + aServicename + "\r\n" + ex.Message + "\r\n");
                Result = 1;
            }
            catch (Exception ex)
            {
                Log("Error starting " + aServicename + "\r\n" + ex.Message + "\r\n");
                Result = 2;
            }

            if (Result == 0)
                Log("Service started.\r\n");

            return Result;
        }

        //---------------------------------------------------------------------------------------------
        private static int UninstallService(string aServiceFile)
        {
            int Result = 0;

            Log("Uninstalling service file " + aServiceFile + "...\r\n");

            string windowsPath = Environment.GetFolderPath(Environment.SpecialFolder.Windows);
            string dotNetDir = System.Runtime.InteropServices.RuntimeEnvironment.GetRuntimeDirectory();
            string instUtil = Path.Combine(dotNetDir, "InstallUtil.exe");

            string sf = "\"" + aServiceFile + "\"";

            try
            {
                Process process = Process.Start(instUtil, " /u " + sf);
                process.WaitForExit();
            }
            catch (Exception ex)
            {
                Log("Error uninstalling service.\r\n" + ex.Message + "\r\n");
            }

            return Result;
        }

        //---------------------------------------------------------------------------------------------
        private static int InstallService(string aServiceFile)
        {
            int Result = 0;

            Log("Installing service file " + aServiceFile + "...\r\n");

            string windowsPath = Environment.GetFolderPath(Environment.SpecialFolder.Windows);
            string dotNetDir = System.Runtime.InteropServices.RuntimeEnvironment.GetRuntimeDirectory();
            string instUtil = Path.Combine(dotNetDir, "InstallUtil.exe");
            string sf = "\"" + aServiceFile + "\"";

            try
            {
                Process process = Process.Start(instUtil, sf);
                process.WaitForExit();
            }
            catch (Exception ex)
            {
                Log("Error uninstalling service.\r\n" + ex.Message + "\r\n");
            }

            return Result;
        }

        //---------------------------------------------------------------------------------------------
        private static int CopyHMRCFiles(string aSource, string aDest)
        {
            int Result = 0;

            Console.WriteLine("Copying files from " + aSource + " to " + aDest + "...\r\n");

            // Get a list of files in the source directory
            string[] sourceFileEntries = Directory.GetFiles(aSource);

            if (sourceFileEntries.Length > 1)
            {
                string rootFilename;
                // Traverse the list of files
                foreach (string srcFile in sourceFileEntries)
                {
                    rootFilename = Path.GetFileName(srcFile);
                    if (rootFilename != thisAppName)
                    {
                        // We can copy this one
                        CopySingleFile(srcFile, Path.Combine(aDest, rootFilename));
                    }
                }
            }

            return Result;
        }

        //---------------------------------------------------------------------------------------------
        private static int CopySingleFile(string aSourceFile, string aDestFile)
        {
            int Result = 0;

            Log("    " + aSourceFile + "...\r\n");

            try
            {
                System.IO.File.Copy(aSourceFile, aDestFile, true);
            }
            catch (Exception ex)
            {
                Log("Error copying file " + aSourceFile + ".\r\n" + ex + "\r\n");
            }

            return Result;
        }

        //---------------------------------------------------------------------------------------------
        public static void Log(string someText, bool append = true)
        {
            thisPath = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
            using (StreamWriter sw = new StreamWriter(Path.Combine(thisPath, "GUUlog.txt"), append))
            {
                sw.WriteLine(DateTime.UtcNow.ToShortDateString() + " " + DateTime.Now.ToLongTimeString() + ": " + someText);
            }
        }

    }
}