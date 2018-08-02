using System;
using System.IO;
using System.Collections;
using System.Collections.Generic;
using System.ServiceProcess;
using System.Text;

namespace WrapperDSRServer
{
    static class Program
    {
        public static bool LogEvents = false;

        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        static void Main()
        {
            ServiceBase[] ServicesToRun;

            // More than one user Service may run within the same process. To add
            // another service to this process, change the following line to
            // create a second service object. For example,
            //
            //   ServicesToRun = new ServiceBase[] {new Service1(), new MySecondUserService()};
            //
            ServicesToRun = new ServiceBase[] { new WrapperDSRServer() };

            ServiceBase.Run(ServicesToRun);
        }
    }

    /// <summary>
    /// DebugFileCtrl
    /// 
    /// Very simple helper class used to log messages to a file
    /// Predominantly used for exception logging.
    /// </summary>
    public class DebugFileCtrl
    {
        #region Private Members
        private string _debugFile;
        #endregion
        #region Constructors
        /// <summary>
        /// This constructor to be called if you want to  
        /// use the standard DebugFile = ChangeFileExt(Application.Exename, '.log');
        /// </summary>
        /// <param name="DeleteIfExists">Set to True if you want to clean up existing log file</param>		
        public DebugFileCtrl(bool DeleteIfExists):
                this(Path.ChangeExtension(Environment.GetCommandLineArgs()[0], ".log"), DeleteIfExists)
        {
            //
            // TODO: Add constructor logic here
            //

        }

        /// <summary>
        ///	Constructor used to specify your own DebugFileName
        /// </summary>
        /// <param name="DebugFileName">Custom DebugFile name (Fully Qualified)</param>
        /// <param name="DeleteIfExists">Set to True if you want to clean up existing log file</param>
        public DebugFileCtrl(string DebugFileName, bool DeleteIfExists)
        {
            _debugFile = DebugFileName;
            if (DeleteIfExists && File.Exists(_debugFile))
            {
                File.Delete(_debugFile);
            }
        }
        #endregion
        #region Public Methods
        /// <summary>
        /// Use this method to return all lines from the file
        /// </summary>
        /// <param name="DeleteAfterRead">Set to true, if you want to Delete the file after the contents have been read</param>
        /// <returns>An ArrayList containing an element for each line of the debug file</returns>
        public ArrayList ReadLog(bool DeleteAfterRead)
        {
            ArrayList lines = new ArrayList();
            string aLine;

            if (File.Exists(_debugFile))
            {
                // iterate through the file and write values into string array
                using (StreamReader sr = new StreamReader(_debugFile))
                {
                    while ((aLine = sr.ReadLine()) != null)
                    {
                        lines.Add(aLine);
                    }
                }
                // check if need to delete file now...
                if (DeleteAfterRead)
                {
                    File.Delete(_debugFile);
                }
            }
            return lines;
        }

        /// <summary>
        /// use this to append a datetime stamped message to the log...
        /// </summary>
        /// <param name="Msg">String value to append to current LogFile</param>
        public void WriteLog(string Msg)
        {
            using (StreamWriter sw = new StreamWriter(_debugFile, true))
            {
                sw.WriteLine(DateTime.Now + ": " + Msg);
            }
        }
        #endregion
    }
}