using System;
using System.Configuration;
using System.Diagnostics;
using System.Drawing;
using System.Drawing.Imaging;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Security.Principal;
using System.Text.RegularExpressions;
using System.Threading;
using System.Windows.Forms;
using System.Net;
using System.Net.Sockets;
using CSH.Exchequer.Bespoke.Network.Email;

//'--
//'-- Generic UNHANDLED error handling class
//'--
//'-- Intended as a last resort for errors which crash our application, so we can get feedback on what
//'-- caused the error.
//'--
//'-- To use: UnhandledExceptionManager.AddHandler() in the STARTUP of your application
//'--
//'-- more background information on Exceptions at:
//'--   http://msdn.microsoft.com/library/default.asp?url=/library/en-us/dnbda/html/exceptdotnet.asp

namespace CSH.Exchequer.Bespoke.ErrorHandling
{
    /// <summary>
    /// Provides standard exception handling services to your application
    /// </summary>
    public partial class ExceptionManager
    {
        /// <summary>
        /// Provides standard exception handling for exceptions your application fails to catch
        /// It's like a MessageBox, but specific to unhandled exceptions
        /// </summary>
        public class Unhandled
        {
            private Unhandled()
            {
                // to keep this class from being creatable as an instance.
            }

            private const string _strLogName = "UnhandledExceptionLog.txt";
            private const string _strScreenshotName = "UnhandledException";
            private const string _strClassName = "UnhandledExceptionManager";
            private const string _strKeyNotPresent = "The property <{0}> is not set in ExceptionManager.Settings";
            private const string _strKeyError = "Error {0} reading property <{1}> from ExceptionManager.Settings";

            private static bool _blnConsoleApp;
            private static bool _blnLogToFileOK;
            private static bool _blnLogToScreenshotOK;
            private static bool _blnLogToEventLogOK;

            private static string _strScreenshotFullPath;
            private static string _strLogFullPath;
            private static string _strException;
            private static string _strExceptionType;

            private static System.Reflection.Assembly _objParentAssembly = null;

            private static System.Reflection.Assembly ParentAssembly()
            {
                if (_objParentAssembly == null)
                {
                    if (System.Reflection.Assembly.GetEntryAssembly() == null)
                    {
                        _objParentAssembly = System.Reflection.Assembly.GetCallingAssembly();
                    }
                    else
                    {
                        _objParentAssembly = System.Reflection.Assembly.GetEntryAssembly();
                    }
                }
                return _objParentAssembly;
            }

            /// <summary>
            /// Adds the handler. This *MUST* be called early in your application to set up global error handling
            /// </summary>
            /// <param name="blnConsoleApp">if set to <c>true</c> [BLN console app].</param>
            public static void AddHandler(bool blnConsoleApp = false)
            {
                //-- we don't need an unhandled exception handler if we are running inside
                //-- the vs.net IDE; it is our "unhandled exception handler" in that case
                if (Settings.IgnoreDebugErrors)
                {
                    if (Debugger.IsAttached)
                        return;
                }

                //-- track the parent assembly that set up error handling
                //-- need to call this NOW so we set it appropriately; otherwise
                //-- we may get the wrong assembly at exception time!
                ParentAssembly();
                
                //-- for winforms applications
                Application.ThreadException -= ThreadExceptionHandler;
                Application.ThreadException += ThreadExceptionHandler;

                //-- for console applications
                System.AppDomain.CurrentDomain.UnhandledException -= UnhandledExceptionHandler;
                System.AppDomain.CurrentDomain.UnhandledException += UnhandledExceptionHandler;

                //-- I cannot find a good way to programatically detect a console app, so that must be specified.
                _blnConsoleApp = blnConsoleApp;
            }

            //--
            //-- handles Application.ThreadException event
            //--
            private static void ThreadExceptionHandler(System.Object sender, System.Threading.ThreadExceptionEventArgs e)
            {
                GenericExceptionHandler(e.Exception);
            }

            //--
            //-- handles AppDomain.CurrentDoamin.UnhandledException event
            //--
            private static void UnhandledExceptionHandler(System.Object sender, UnhandledExceptionEventArgs args)
            {
                Exception objException = (Exception)args.ExceptionObject;
                GenericExceptionHandler(objException);
            }

            //--
            //-- exception-safe file attrib retrieval; we don't care if this fails
            //--
            private static DateTime AssemblyFileTime(System.Reflection.Assembly objAssembly)
            {
                try
                {
                    return System.IO.File.GetLastWriteTime(objAssembly.Location);
                }
                catch (Exception)
                {
                    return DateTime.MaxValue;
                }
            }

            //--
            //-- returns build datetime of assembly
            //-- assumes default assembly value in AssemblyInfo:
            //-- <Assembly: AssemblyVersion("1.0.*")>
            //--
            //-- filesystem create time is used, if revision and build were overridden by user
            //--
            private static DateTime AssemblyBuildDate(System.Reflection.Assembly objAssembly, bool blnForceFileDate = false)
            {
                System.Version objVersion = objAssembly.GetName().Version;
                DateTime dtBuild = default(DateTime);

                if (blnForceFileDate)
                {
                    dtBuild = AssemblyFileTime(objAssembly);
                }
                else
                {
                    dtBuild = Convert.ToDateTime("01/01/2000").AddDays((double)objVersion.Build).AddSeconds((double)(objVersion.Revision * 2));
                    if (TimeZone.IsDaylightSavingTime(DateTime.Now, TimeZone.CurrentTimeZone.GetDaylightChanges(DateTime.Now.Year)))
                    {
                        dtBuild = dtBuild.AddHours(1);
                    }
                    if (dtBuild > DateTime.Now | objVersion.Build < 730 | objVersion.Revision == 0)
                    {
                        dtBuild = AssemblyFileTime(objAssembly);
                    }
                }

                return dtBuild;
            }

            //--
            //-- turns a single stack frame object into an informative string
            //--
            private static string StackFrameToString(StackFrame sf)
            {
                System.Text.StringBuilder sb = new System.Text.StringBuilder();
                int intParam = 0;
                MemberInfo mi = sf.GetMethod();

                //-- build method name
                sb.Append("   ");
                sb.Append(mi.DeclaringType.Namespace);
                sb.Append(".");
                sb.Append(mi.DeclaringType.Name);
                sb.Append(".");
                sb.Append(mi.Name);

                //-- build method params
                ParameterInfo[] objParameters = sf.GetMethod().GetParameters();
                ParameterInfo objParameter = null;
                sb.Append("(");
                intParam = 0;
                foreach (ParameterInfo objParameter_loopVariable in objParameters)
                {
                    objParameter = objParameter_loopVariable;
                    intParam += 1;
                    if (intParam > 1)
                        sb.Append(", ");
                    sb.Append(objParameter.Name);
                    sb.Append(" As ");
                    sb.Append(objParameter.ParameterType.Name);
                }
                sb.Append(")");
                sb.Append(Environment.NewLine);

                //-- if source code is available, append location info
                sb.Append("       ");
                if (sf.GetFileName() == null || sf.GetFileName().Length == 0)
                {
                    sb.Append(System.IO.Path.GetFileName(ParentAssembly().CodeBase));
                    //-- native code offset is always available
                    sb.Append(": N ");
                    sb.Append(string.Format("{0:#00000}", sf.GetNativeOffset()));
                }
                else
                {
                    sb.Append(System.IO.Path.GetFileName(sf.GetFileName()));
                    sb.Append(": line ");
                    sb.Append(string.Format("{0:#0000}", sf.GetFileLineNumber()));
                    sb.Append(", col ");
                    sb.Append(string.Format("{0:#00}", sf.GetFileColumnNumber()));
                    //-- if IL is available, append IL location info
                    if (sf.GetILOffset() != StackFrame.OFFSET_UNKNOWN)
                    {
                        sb.Append(", IL ");
                        sb.Append(string.Format("{0:#0000}", sf.GetILOffset()));
                    }
                }
                sb.Append(Environment.NewLine);
                return sb.ToString();
            }

            //--
            //-- enhanced stack trace generator
            //--
            private static string EnhancedStackTrace(StackTrace objStackTrace, string strSkipClassName = "")
            {
                int intFrame = 0;

                System.Text.StringBuilder sb = new System.Text.StringBuilder();

                sb.Append(Environment.NewLine);
                sb.Append("---- Stack Trace ----");
                sb.Append(Environment.NewLine);

                for (intFrame = 0; intFrame <= objStackTrace.FrameCount - 1; intFrame++)
                {
                    StackFrame sf = objStackTrace.GetFrame(intFrame);
                    MemberInfo mi = sf.GetMethod();

                    if (!string.IsNullOrEmpty(strSkipClassName) && mi.DeclaringType.Name.IndexOf(strSkipClassName) > -1)
                    {
                        //-- don't include frames with this name
                    }
                    else
                    {
                        sb.Append(StackFrameToString(sf));
                    }
                }
                sb.Append(Environment.NewLine);

                return sb.ToString();
            }

            //--
            //-- enhanced stack trace generator (exception)
            //--
            private static string EnhancedStackTrace(Exception objException)
            {
                StackTrace objStackTrace = new StackTrace(objException, true);
                return EnhancedStackTrace(objStackTrace);
            }

            //--
            //-- enhanced stack trace generator (no params)
            //--
            private static string EnhancedStackTrace()
            {
                StackTrace objStackTrace = new StackTrace(true);
                return EnhancedStackTrace(objStackTrace, "ExceptionManager");
            }

            //--
            //-- generic exception handler; the various specific handlers all call into this sub
            //--

            private static void GenericExceptionHandler(Exception objException)
            {
                //-- turn the exception into an informative string
                try
                {
                    _strException = ExceptionToString(objException);
                    _strExceptionType = objException.GetType().FullName;
                }
                catch (Exception ex)
                {
                    _strException = "Error '" + ex.Message + "' while generating exception string";
                    _strExceptionType = "";
                }

                if (!_blnConsoleApp)
                {
                    Cursor.Current = System.Windows.Forms.Cursors.WaitCursor;
                }

                //-- log this error to various locations
                try
                {
                    //-- screenshot takes around 1 second
                    if (Settings.TakeScreenshot)
                        ExceptionToScreenshot();
                    //-- event logging takes < 100ms
                    if (Settings.LogToEventLog)
                        ExceptionToEventLog();
                    //-- textfile logging takes < 50ms
                    if (Settings.LogToFile)
                        ExceptionToFile();
                    //-- email takes under 1 second
                    if (Settings.SendEmail)
                        ExceptionToEmail();
                }
                catch (Exception)
                {
                    //-- generic catch because any exceptions inside the UEH
                    //-- will cause the code to terminate immediately
                }

                if (!_blnConsoleApp)
                {
                    Cursor.Current = System.Windows.Forms.Cursors.Default;
                }
                //-- display message to the user
                if (Settings.DisplayDialog)
                    ExceptionToUI();

                if (Settings.KillAppOnException)
                {
                    //As far as the email not being send when a user closes the dialog too fast, 
                    //I see that you were threading off the email to speed display of the exception 
                    //dialog. Well, if the user clicks ok before the SMTP can be sent, the thread 
                    //is killed immediately and the email will never make it out. To fix that, I changed 
                    //the scope of the objThread to class level and right before the KillApp() call I 
                    //do a objThread.Join(new TimeSpan(0, 0, 30)) to wait up to 30 seconds for it's 
                    //completion. Now the email is sent reliably. Changing the scope of the objThread 
                    //mandated that the class not be static (Shared) anymore, so I changed the relevant 
                    //functions and I instantiate an object of the exception handler to AddHandler() with.

                    //objThread.Join(new TimeSpan(0, 0, 30));	// to wait 30 seconds for completion
                    KillApp();
                    Application.Exit();
                }
            }

            //--
            //-- This is in a private routine for .NET security reasons
            //-- if this line of code is in a sub, the entire sub is tagged as full trust
            //--
            private static void KillApp()
            {
                System.Diagnostics.Process.GetCurrentProcess().Kill();
            }

            //--
            //-- turns exception into something an average user can hopefully
            //-- understand; still very technical
            //--
            private static string FormatExceptionForUser(bool blnConsoleApp)
            {
                System.Text.StringBuilder objStringBuilder = new System.Text.StringBuilder();
                string strBullet = null;
                if (blnConsoleApp)
                {
                    strBullet = "-";
                }
                else
                {
                    strBullet = "•";
                }

                if (!blnConsoleApp)
                {
                    objStringBuilder.Append("The development team was automatically notified of this problem. ");
                    objStringBuilder.Append("If you need immediate assistance, contact (contact).");
                }
                objStringBuilder.Append(Environment.NewLine);
                objStringBuilder.Append(Environment.NewLine);
                objStringBuilder.Append("The following information about the error was automatically captured: ");
                objStringBuilder.Append(Environment.NewLine);
                objStringBuilder.Append(Environment.NewLine);
                if (Settings.TakeScreenshot)
                {
                    objStringBuilder.Append(" ");
                    objStringBuilder.Append(strBullet);
                    objStringBuilder.Append(" ");
                    if (_blnLogToScreenshotOK)
                    {
                        objStringBuilder.Append("a screenshot was taken of the desktop at:");
                        objStringBuilder.Append(Environment.NewLine);
                        objStringBuilder.Append("   ");
                        objStringBuilder.Append(_strScreenshotFullPath);
                    }
                    else
                    {
                        objStringBuilder.Append("a screenshot could NOT be taken of the desktop.");
                    }
                    objStringBuilder.Append(Environment.NewLine);
                }
                if (Settings.LogToEventLog)
                {
                    objStringBuilder.Append(" ");
                    objStringBuilder.Append(strBullet);
                    objStringBuilder.Append(" ");
                    if (_blnLogToEventLogOK)
                    {
                        objStringBuilder.Append("an event was written to the application log");
                    }
                    else
                    {
                        objStringBuilder.Append("an event could NOT be written to the application log");
                    }
                    objStringBuilder.Append(Environment.NewLine);
                }
                if (Settings.LogToFile)
                {
                    objStringBuilder.Append(" ");
                    objStringBuilder.Append(strBullet);
                    objStringBuilder.Append(" ");
                    if (_blnLogToFileOK)
                    {
                        objStringBuilder.Append("details were written to a text log at:");
                    }
                    else
                    {
                        objStringBuilder.Append("details could NOT be written to the text log at:");
                    }
                    objStringBuilder.Append(Environment.NewLine);
                    objStringBuilder.Append("   ");
                    objStringBuilder.Append(_strLogFullPath);
                    objStringBuilder.Append(Environment.NewLine);
                }
                if (Settings.SendEmail)
                {
                    objStringBuilder.Append(" ");
                    objStringBuilder.Append(strBullet);
                    objStringBuilder.Append(" ");
                    objStringBuilder.Append("attempted to send an email to: ");
                    objStringBuilder.Append(Environment.NewLine);
                    objStringBuilder.Append("   ");
                    objStringBuilder.Append(Settings.EmailTo);
                    objStringBuilder.Append(Environment.NewLine);
                }
                objStringBuilder.Append(Environment.NewLine);
                objStringBuilder.Append(Environment.NewLine);
                objStringBuilder.Append("Detailed error information follows:");
                objStringBuilder.Append(Environment.NewLine);
                objStringBuilder.Append(Environment.NewLine);
                objStringBuilder.Append(_strException);
                return objStringBuilder.ToString();
            }

            //--
            //-- display a dialog to the user; otherwise we just terminate with no alert at all!
            //--

            private static void ExceptionToUI()
            {
                const string _strWhatHappened = "There was an unexpected error in (app). This may be due to a programming bug.";
                string _strHowUserAffected = null;
                const string _strWhatUserCanDo = "Restart (app), and try repeating your last action. Try alternative methods of performing the same action.";

                if (ExceptionManager.Settings.KillAppOnException)
                {
                    _strHowUserAffected = "When you click OK, (app) will close.";
                }
                else
                {
                    _strHowUserAffected = "The action you requested was not performed.";
                }

                if (!_blnConsoleApp)
                {
                    //-- don't send ANOTHER email if we are already doing so!
                    Handled.IsErrorToBeEmailed = !Settings.SendEmail;
                    //-- pop the dialog
                    Handled.ShowDialog(_strWhatHappened, _strHowUserAffected, _strWhatUserCanDo, FormatExceptionForUser(false), null, MessageBoxButtons.OK, MessageBoxIcon.Stop);
                }
                else
                {
                    //-- note that writing to console pauses for ENTER
                    //-- otherwise console window just terminates immediately
                    ExceptionToConsole();
                }
            }

            //--
            //-- for non-web hosted apps, returns:
            //--   "[path]\bin\YourAssemblyName."
            //-- for web hosted apps, returns URL with non-filesystem chars removed:
            //--   "c:\http___domain\path\YourAssemblyName."
            private static string GetApplicationPath()
            {
                if (ParentAssembly().CodeBase.StartsWith("http://"))
                {
                    //return "c:\\" + Regex.Replace(ParentAssembly().CodeBase(), "[\\/\\\\\\:\\*\\?\\\"\\<\\>\\|]", "_") + ".";
                    return (@"c:\" + Regex.Replace(ParentAssembly().CodeBase, "[\\/\\\\\\:\\*\\?\\\"\\<\\>\\|]", "_") + ".");
                }
                else
                {
                    return System.AppDomain.CurrentDomain.BaseDirectory + System.AppDomain.CurrentDomain.FriendlyName + ".";
                }
            }

            //--
            //-- take a desktop screenshot of our exception
            //-- note that this fires BEFORE the user clicks on the OK dismissing the crash dialog
            //-- so the crash dialog itself will not be displayed
            //--
            private static void ExceptionToScreenshot()
            {
                //-- note that screenshotname does NOT include the file type extension
                try
                {
                    TakeScreenshotPrivate(GetApplicationPath() + _strScreenshotName);
                    _blnLogToScreenshotOK = true;
                }
                catch (Exception)
                {
                    _blnLogToScreenshotOK = false;
                }
            }

            //--
            //-- write an exception to the Windows NT event log
            //--
            private static void ExceptionToEventLog()
            {
                try
                {
                    System.Diagnostics.EventLog.WriteEntry(System.AppDomain.CurrentDomain.FriendlyName, Environment.NewLine + _strException, EventLogEntryType.Error);
                    _blnLogToEventLogOK = true;
                }
                catch (Exception)
                {
                    _blnLogToEventLogOK = false;
                }
            }

            //--
            //-- write an exception to the console
            //--
            private static void ExceptionToConsole()
            {
                Console.WriteLine("This application encountered an unexpected problem.");
                Console.WriteLine(FormatExceptionForUser(true));
                Console.WriteLine("The application must now terminate. Press ENTER to continue...");
                Console.ReadLine();
            }

            //--
            //-- write an exception to a text file
            //--
            private static void ExceptionToFile()
            {
                _strLogFullPath = GetApplicationPath() + _strLogName;
                try
                {
                    using (System.IO.StreamWriter objStreamWriter = new System.IO.StreamWriter(_strLogFullPath, true))
                    {
                        objStreamWriter.Write(_strException);
                        objStreamWriter.WriteLine();
                    }
                    _blnLogToFileOK = true;

                }
                catch (Exception)
                {
                    _blnLogToFileOK = false;
                }
            }

            //--
            //-- this is the code that executes in the spawned thread
            //--
            private static void ThreadHandler()
            {
                EmailClient objMail = new EmailClient();
                EmailMessage objMailMessage = new EmailMessage();

                objMailMessage.To = Settings.EmailTo;
                objMailMessage.From = Settings.EmailFrom;
                objMailMessage.Subject = "Unhandled Exception notification - " + _strExceptionType;
                objMailMessage.Body = _strException;
                if (Settings.TakeScreenshot & Settings.EmailScreenshot)
                {
                    objMailMessage.AttachmentPath = _strScreenshotFullPath;
                }
                try
                {
                    // call SendMail method in SimpleMail class
                    objMail.SendMail(objMailMessage);
                }
                catch (Exception)
                {
                    //-- don't do anything; sometimes SMTP isn't available, which generates an exception
                    //-- and an exception in the unhandled exception manager.. is bad news.
                }
            }

            //--
            //-- send an exception via email
            //--
            private static void ExceptionToEmail()
            {
                //-- spawn off the email send attempt as a thread for improved throughput
                Thread objThread = new Thread(new ThreadStart(ThreadHandler));
                objThread.Name = "SendExceptionEmail";
                objThread.Start();
            }

            //--
            //-- exception-safe WindowsIdentity.GetCurrent retrieval returns "domain\username"
            //-- per MS, this sometimes randomly fails with "Access Denied" particularly on NT4
            //--
            private static string CurrentWindowsIdentity()
            {
                try
                {
                    //return System.Security.Principal.WindowsIdentity.GetCurrent().Name();
                    return WindowsIdentity.GetCurrent().Name;
                }
                catch (Exception)
                {
                    return "";
                }
            }

            //--
            //-- exception-safe "domain\username" retrieval from Environment
            //--
            private static string CurrentEnvironmentIdentity()
            {
                try
                {
                    return System.Environment.UserDomainName + "\\" + System.Environment.UserName;
                }
                catch (Exception)
                {
                    return "";
                }
            }

            //--
            //-- retrieve identity with fallback on error to safer method
            //--
            private static string UserIdentity()
            {
                string strTemp = null;
                strTemp = CurrentWindowsIdentity();
                if (string.IsNullOrEmpty(strTemp))
                {
                    strTemp = CurrentEnvironmentIdentity();
                }
                return strTemp;
            }

            //--
            //-- gather some system information that is helpful to diagnosing
            //-- exception
            //--
            static internal string SysInfoToString(bool blnIncludeStackTrace = false)
            {
                System.Text.StringBuilder objStringBuilder = new System.Text.StringBuilder();

                objStringBuilder.Append("Date and Time:         ");
                objStringBuilder.Append(DateTime.Now);
                objStringBuilder.Append(Environment.NewLine);

                objStringBuilder.Append("Machine Name:          ");
                try
                {
                    objStringBuilder.Append(Environment.MachineName);
                }
                catch (Exception e)
                {
                    objStringBuilder.Append(e.Message);
                }
                objStringBuilder.Append(Environment.NewLine);

                objStringBuilder.Append("IP Address:            ");
                objStringBuilder.Append(GetCurrentIP());
                objStringBuilder.Append(Environment.NewLine);

                objStringBuilder.Append("Current User:          ");
                objStringBuilder.Append(UserIdentity());
                objStringBuilder.Append(Environment.NewLine);
                objStringBuilder.Append(Environment.NewLine);

                objStringBuilder.Append("Application Domain:    ");
                try
                {
                    objStringBuilder.Append(System.AppDomain.CurrentDomain.FriendlyName);
                }
                catch (Exception e)
                {
                    objStringBuilder.Append(e.Message);
                }

                objStringBuilder.Append(Environment.NewLine);
                objStringBuilder.Append("Assembly Codebase:     ");
                try
                {
                    objStringBuilder.Append(ParentAssembly().CodeBase);
                }
                catch (Exception e)
                {
                    objStringBuilder.Append(e.Message);
                }
                objStringBuilder.Append(Environment.NewLine);

                objStringBuilder.Append("Assembly Full Name:    ");
                try
                {
                    objStringBuilder.Append(ParentAssembly().FullName);
                }
                catch (Exception e)
                {
                    objStringBuilder.Append(e.Message);
                }
                objStringBuilder.Append(Environment.NewLine);

                objStringBuilder.Append("Assembly Version:      ");
                try
                {
                    objStringBuilder.Append(ParentAssembly().GetName().Version.ToString());
                }
                catch (Exception e)
                {
                    objStringBuilder.Append(e.Message);
                }
                objStringBuilder.Append(Environment.NewLine);

                objStringBuilder.Append("Assembly Build Date:   ");
                try
                {
                    objStringBuilder.Append(AssemblyBuildDate(ParentAssembly()).ToString());
                }
                catch (Exception e)
                {
                    objStringBuilder.Append(e.Message);
                }
                objStringBuilder.Append(Environment.NewLine);
                objStringBuilder.Append(Environment.NewLine);

                if (blnIncludeStackTrace)
                {
                    objStringBuilder.Append(EnhancedStackTrace());
                }

                return objStringBuilder.ToString();
            }

            //--
            //-- translate exception object to string, with additional system info
            //--
            static internal string ExceptionToString(Exception objException)
            {
                System.Text.StringBuilder objStringBuilder = new System.Text.StringBuilder();

                if ((objException.InnerException != null))
                {
                    //-- sometimes the original exception is wrapped in a more relevant outer exception
                    //-- the detail exception is the "inner" exception
                    //-- see http://msdn.microsoft.com/library/default.asp?url=/library/en-us/dnbda/html/exceptdotnet.asp

                    objStringBuilder.Append("(Inner Exception)");
                    objStringBuilder.Append(Environment.NewLine);
                    objStringBuilder.Append(ExceptionToString(objException.InnerException));
                    objStringBuilder.Append(Environment.NewLine);
                    objStringBuilder.Append("(Outer Exception)");
                    objStringBuilder.Append(Environment.NewLine);
                }

                //-- get general system and app information
                objStringBuilder.Append(SysInfoToString());

                //-- get exception-specific information
                objStringBuilder.Append("Exception Source:      ");
                try
                {
                    objStringBuilder.Append(objException.Source);
                }
                catch (Exception e)
                {
                    objStringBuilder.Append(e.Message);
                }
                objStringBuilder.Append(Environment.NewLine);

                objStringBuilder.Append("Exception Type:        ");
                try
                {
                    objStringBuilder.Append(objException.GetType().FullName);
                }
                catch (Exception e)
                {
                    objStringBuilder.Append(e.Message);
                }
                objStringBuilder.Append(Environment.NewLine);

                objStringBuilder.Append("Exception Message:     ");
                try
                {
                    objStringBuilder.Append(objException.Message);
                }
                catch (Exception e)
                {
                    objStringBuilder.Append(e.Message);
                }
                objStringBuilder.Append(Environment.NewLine);

                objStringBuilder.Append("Exception Target Site: ");
                try
                {
                    objStringBuilder.Append(objException.TargetSite.Name);
                }
                catch (Exception e)
                {
                    objStringBuilder.Append(e.Message);
                }
                objStringBuilder.Append(Environment.NewLine);

                try
                {
                    string x = EnhancedStackTrace(objException);
                    objStringBuilder.Append(x);
                }
                catch (Exception e)
                {
                    objStringBuilder.Append(e.Message);
                }
                objStringBuilder.Append(Environment.NewLine);

                return objStringBuilder.ToString();
            }

            //--
            //-- returns ImageCodecInfo for the specified MIME type
            //--
            private static ImageCodecInfo GetEncoderInfo(string strMimeType)
            {
                int j = 0;
                System.Drawing.Imaging.ImageCodecInfo[] objImageCodecInfo = null;
                objImageCodecInfo = System.Drawing.Imaging.ImageCodecInfo.GetImageEncoders();

                j = 0;
                while (j < objImageCodecInfo.Length)
                {
                    if (objImageCodecInfo[j].MimeType == strMimeType)
                    {
                        return objImageCodecInfo[j];
                    }
                    j += 1;
                }

                return null;
            }

            //--
            //-- save bitmap object to JPEG of specified quality level
            //--
            private static void BitmapToJPEG(Bitmap objBitmap, string strFilename, long lngCompression = 75)
            {
                using (System.Drawing.Imaging.EncoderParameters objEncoderParameters = new System.Drawing.Imaging.EncoderParameters(1))
                {
                    System.Drawing.Imaging.ImageCodecInfo objImageCodecInfo = GetEncoderInfo("image/jpeg");

                    objEncoderParameters.Param[0] = new System.Drawing.Imaging.EncoderParameter(System.Drawing.Imaging.Encoder.Quality, lngCompression);
                    objBitmap.Save(strFilename, objImageCodecInfo, objEncoderParameters);
                }
            }

            //--
            //-- takes a screenshot of the desktop and saves to filename and format specified
            //--
            private static void TakeScreenshotPrivate(string strFilename)
            {
                Rectangle objRectangle = Screen.PrimaryScreen.Bounds;
                using (Bitmap objBitmap = new Bitmap(objRectangle.Right, objRectangle.Bottom))
                {
                    Graphics objGraphics = null;
                    IntPtr hdcDest = default(IntPtr);
                    int hdcSrc = 0;
                    const int SRCCOPY = 0xcc0020;
                    string strFormatExtension = null;

                    //objGraphics = objGraphics.FromImage(objBitmap);
                    objGraphics = Graphics.FromImage(objBitmap);

                    //-- get a device context to the windows desktop and our destination  bitmaps
                    hdcSrc = NativeMethods.GetDC(0);
                    hdcDest = objGraphics.GetHdc();
                    //-- copy what is on the desktop to the bitmap
                    NativeMethods.BitBlt(hdcDest.ToInt32(), 0, 0, objRectangle.Right, objRectangle.Bottom, hdcSrc, 0, 0, SRCCOPY);
                    //-- release device contexts
                    objGraphics.ReleaseHdc(hdcDest);
                    NativeMethods.ReleaseDC(0, hdcSrc);

                    strFormatExtension = Settings.ScreenshotImageFormat.ToString().ToLower();
                    if (System.IO.Path.GetExtension(strFilename) != "." + strFormatExtension)
                    {
                        strFilename += "." + strFormatExtension;
                    }
                    switch (strFormatExtension)
                    {
                        case "jpeg":
                            BitmapToJPEG(objBitmap, strFilename, 80);
                            break;
                        default:
                            objBitmap.Save(strFilename, Settings.ScreenshotImageFormat);
                            break;
                    }
                }
                //-- save the complete path/filename of the screenshot for possible later use
                _strScreenshotFullPath = strFilename;
            }

            //--
            //-- get IP address of this machine
            //-- not an ideal method for a number of reasons (guess why!)
            //-- but the alternatives are very ugly
            //--
            private static string GetCurrentIP()
            {
                try
                {
                    System.Net.IPHostEntry host;
                    string localIP = "?";
                    host = System.Net.Dns.GetHostEntry(System.Net.Dns.GetHostName());
                    foreach (System.Net.IPAddress ip in host.AddressList)
                    {
                        if (ip.AddressFamily == (AddressFamily.InterNetwork))
                        {
                            localIP = ip.ToString();
                            break;
                        }
                    }
                    return localIP;
                }
                catch (Exception)
                {
                    return "127.0.0.1";
                }
            }
        }
    }
}