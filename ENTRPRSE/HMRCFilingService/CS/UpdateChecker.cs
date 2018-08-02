using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Reflection;
using System.IO;
using System.Timers;
using System.Threading;

namespace HMRCFilingService
{
    class UpdateChecker
    {
        private const string updaterExeName = "GUU.exe";

        private DateTime UPDATE_CHECK_TIME_1;
        private DateTime UPDATE_CHECK_TIME_2;

        private bool performInitialCheck = false;
        private bool updateAvailable = false;
        private System.Timers.Timer updateTimer;
        private string sourceDir;
        private string destDir;

        private VAT100Database dbHandler = null; // Has a COM Toolkit we can use

        /// <summary>
        /// Constructor
        /// </summary>
        public UpdateChecker()
        {
            DateTime now = DateTime.Now;
            UPDATE_CHECK_TIME_1 = new DateTime(now.Year, now.Month, now.Day, 7, 0, 0, 0);  // 07:00
            UPDATE_CHECK_TIME_2 = new DateTime(now.Year, now.Month, now.Day, 21, 0, 0, 0); // 21:00

            dbHandler = VAT100Database.Instance;

            // Get the directories
            sourceDir = dbHandler.tToolkit.Configuration.EnterpriseDirectory + @"HMRC Filing Service\";
            destDir = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);

            // Create the timer and set its interval
            updateTimer = new System.Timers.Timer(60000); // Once per minute
            updateTimer.Elapsed += TimerCallback;
            updateTimer.AutoReset = true;
            updateTimer.Enabled = true;

            // Do an initial check at the first minute (don't do it straight away, because the service
            // needs time to finish starting up).
            performInitialCheck = true;
        }

        //---------------------------------------------------------------------------------------------
        private void TimerCallback(Object source, ElapsedEventArgs e)
        {
            // Check whether time now (to the nearest minute) matches either of the test times
            DateTime now = DateTime.Now;

            if (((now.Hour == UPDATE_CHECK_TIME_1.Hour) && (now.Minute == UPDATE_CHECK_TIME_1.Minute)) ||
                ((now.Hour == UPDATE_CHECK_TIME_2.Hour) && (now.Minute == UPDATE_CHECK_TIME_2.Minute)) ||
                performInitialCheck)
            {
                PerformUpdateCheck();
                performInitialCheck = false;
            }
        }

        //---------------------------------------------------------------------------------------------
        private void PerformUpdateCheck()
        {
            DateTime sourceFileTime;
            DateTime destFileTime;
            string sourceFileSpec;
            string destFileSpec;

            Logger.Log("Performing Update Check");

            updateAvailable = false;

            // Compare the times and dates of the files in the HMRC Filing Service folder with the local ones.
            // Get a list of files in the source folder
            // Process the list of files found in the directory.
            // string[] sourceFileEntries = Directory.GetFiles(sourceDir);
            string[] sourceFileEntries = new string[3] { "GUU.exe", "HMRCFilingService.exe", "BespokeFuncs.dll" };
            foreach (string sourceFilename in sourceFileEntries)
            {
                Logger.Log(string.Format("Checking {0}", sourceFilename));

                sourceFileSpec = Path.Combine(sourceDir, sourceFilename);
                destFileSpec = Path.Combine(destDir, sourceFilename);

                // Get the file timestamp
                sourceFileTime = File.GetLastWriteTime(sourceFileSpec);

                Logger.Log(string.Format("{0}", sourceFileTime));

                if (File.Exists(destFileSpec))
                {
                    // File exists, so get its creation time
                    destFileTime = File.GetLastWriteTime(destFileSpec);

                    Logger.Log(string.Format("{0}", destFileTime));

                    if (sourceFileTime > destFileTime)
                    {
                        // Source has a later time, so an update is available
                        updateAvailable = true;

                        // If it's the updater program, we need to copy it across now so that we run the latest version.
                        if (sourceFilename == updaterExeName)
                        {
                            Logger.Log(string.Format("Copying {0} to {1}", sourceFileSpec, destFileSpec));
                            // A new updater is available, so we need to copy it across before executing it
                            System.IO.File.Copy(sourceFileSpec, destFileSpec, true); // true = overwrite
                        }
                        break;
                    }
                }
                else
                {
                    // File doesn't exist in destination, so the update must be adding it
                    updateAvailable = true;
                    break;
                }
            }

            // If an update is available, then invoke the Updater
            if (updateAvailable)
            {
                Logger.Log("Update available");
                try
                {
                    // Stop the timer from firing again.  It will restart when the updated service restarts.
                    Stop();

                    // Start the updater (GUU.exe).  Don't wait for it to finish because it needs to stop this service.
                    string sd = "\"" + sourceDir.Replace("\\", "\\\\") + "\"";
                    string dd = "\"" + destDir.Replace("\\", "\\\\") + "\"";

                    string command = Path.Combine(destDir, updaterExeName);
                    string arguments = string.Format("{0} {1}", sd, dd);

                    Logger.Log("Attempting to start GUU");
                    Process.Start(command, arguments);
                }
                catch (Exception ex)
                {
                    Logger.Log(string.Format("Error starting GUU: {0}", ex.Message));
                }
            }
            else
            {
                Logger.Log("Service is up to date");
            }
        }


        public void Start()
        {
            updateTimer.Enabled = true;
        }

        public void Stop()
        {
            updateTimer.Enabled = false;
        }
    }
}
